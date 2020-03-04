function New-Chart {
    [Cmdletbinding()]
    param(
        [Parameter()]
        [string]$Id = (New-Guid).Guid,
        [Parameter()]
        [scriptblock]$Content, 
        [Parameter()]
        [switch]$ForceFit, 
        [Parameter()]
        [PSTypeName("antv.chart.title")]$Title, 
        [Parameter()]
        [PSTypeName("antv.chart.description")]$Description, 
        [Parameter()]
        [string]$XField, 
        [Parameter()]
        [string]$YField,
        [Parameter(ValueFromPipeline)]
        [ValidateSet(
            "Line", "Bar", "Column", "Area", "Pie", "Ring", 
            "StackBar", "PercentageStackBar", "GroupBar", "RangeBar", "StackColumn", 
            "PercentageStackColumn", "GroupColumn", "Histogram", "Waterfall", "RangeColumn",
            "StackArea", "PercentageStackArea", "StepLine", "Scatter", "Bubble", 
            "Radar", "Heatmap", "Matrix", "Funnel", "Treemap", "Liquid", "Gauge", 
            "OverlappedComboPlot", "Bullet", "TinyArea", "TinyLine", "TinyColumn", "RingProgress", "Progress", "WordCloud")]
        [string]$ChartType,
        [Parameter()]
        [PSTypeName("antv.chart.legend")]$Legend,
        [Parameter()]
        [PSTypeName("antv.chart.label")]$Label,
        [Parameter()]
        [PSTypeName("antv.chart.interactions")]$Interactions,
        [Parameter()]
        [PSTypeName("antv.chart.tooltip")]$ToolTip
    )
    DynamicParam {
        if($ChartType -match "Ring"){
            $dynParam = Add-DynamicParameter -Parameters @{Name = 'AngleField'; Type = 'string'}
            return $dynParam
        }
        elseif($ChartType -match "Progress"){
            $dynParam = Add-DynamicParameter  -Parameters @(
                @{Name = 'width'; Type = 'int' }
                @{Name = 'height'; Type = 'int' }
                @{Name = 'percent'; Type = 'int' }
            )
            return $dynParam
        }
    }
    end {
        $Chart = @{
            type         = "chart"
            id           = $Id
            isPlugin     = $true
            assetId      = $ChartAssetId
            forceFit     = $ForceFit.IsPresent
            content      = $Content.Invoke() | ConvertTo-Json -Compress
            title        = $Title
            description  = $description
            xField       = $XField
            yField       = $YField
            chartType    = $ChartType
            legend       = $Legend
            tooltip      = $ToolTip
            label        = $Label
            interactions = $Interactions
        }
        foreach($DynamicParameter in $dynParam.keys){
            $Chart.Add($DynamicParameter, $PSBoundParameters[$DynamicParameter])
        }
        $Chart
    }
}

function New-ChartTitle {
    [CmdletBinding()]
    [OutputType("antv.chart.title")]
    param(
        [Parameter()]
        [switch]$Visible,
        [Parameter()]
        [string]$Text,
        [Parameter()]
        [hashtable]$Style
    )

    end {
        $Title = @{
            visible = $Visible.IsPresent
            text    = $Text
            style   = $Style    
        }
        $Title.PSTypeNames.Insert(0, "antv.chart.title") | Out-Null
        $Title
    }
}
function New-ChartDescription {
    [CmdletBinding()]
    [OutputType("antv.chart.description")]
    param(
        [Parameter()]
        [switch]$Visible,
        [Parameter()]
        [string]$Text,
        [Parameter()]
        [hashtable]$Style
    )

    end {
        $Description = @{
            visible = $Visible.IsPresent
            text    = $Text
            style   = $Style    
        }
        $Description.PSTypeNames.Insert(0, "antv.chart.description") | Out-Null
        $Description
    }
}
function New-ChartLegend {
    [CmdletBinding()]
    [OutputType("antv.chart.legend")]
    param(
        [Parameter()]
        [switch]$Visible,
        [Parameter()]
        [ValidateSet(
            "left-top", "left-center", "left-bottom", "right-top", "right-center", "right-bottom", 
            "top-left", "top-center", "top-right", "bottom-left", "bottom-center", "bottom-right"
        )]
        [string]$Position,
        [Parameter()]
        [ValidateSet(
            "circle", "square", "bowtie", "diamond", "hexagon", "triangle", 
            "triang", "le-down", "hollowCircle", "hollowSquare", "hollow Bowtie", "hollowDiamond", 
            "hollowHexagon", "hollowTriangle", " hollowTriangle-down", "cross", "tick", "plus", "hyphen", "line"
        )]
        [string]$Marker,
        [Parameter()]
        [int]$OffsetX,
        [Parameter()]
        [int]$OffsetY
    )

    end {
        $Legend = @{
            visible  = $Visible.IsPresent
            position = $Position
            marker   = $Marker
            offsetX  = $OffsetX
            offsetY  = $OffsetY    
        }
        $Legend.PSTypeNames.Insert(0, "antv.chart.legend") | Out-Null
        $Legend
    }
}

function New-ChartLabel {
    [CmdletBinding()]
    [OutputType("antv.chart.label")]
    param(
        [Parameter()]
        [switch]$Visible,
        [Parameter()]
        [ValidateSet("point", "line")]
        [string]$Type,
        [Parameter()]
        [int]$OffsetX,
        [Parameter()]
        [int]$OffsetY,
        [Parameter()]
        [hashtable]$Style
    )

    end {
        $Label = @{
            visible = $Visible.IsPresent
            type    = $Type
            offsetX = $OffsetX
            offsetY = $OffsetY    
            style   = $Style    
        }
        $Label.PSTypeNames.Insert(0, "antv.chart.label") | Out-Null
        $Label
    }
}
function New-ChartTooltip {
    [CmdletBinding()]
    [OutputType("antv.chart.tooltip")]
    param(
        [Parameter(HelpMessage = "whether to show tooltip")]
        [switch]$Visible,
        [Parameter()]
        [switch]$Shared,
        [Parameter()]
        [PSTypeName("antv.chart.tooltip.crosshairs")]$Crosshairs,
        [Parameter(HelpMessage = "This method allows user to pass in an dom or dom id as tooltip container.")]
        [object]$CustomTooltip
    )

    end {
        $Tooltip = @{
            visible       = $Visible.IsPresent
            shared        = $Shared.IsPresent
            crosshairs    = $Crosshairs
            customTooltip = $CustomTooltip
        }
        $Tooltip.PSTypeNames.Insert(0, "antv.chart.tooltip") | Out-Null
        $Tooltip
    }
}

function New-ChartTooltipCrosshairs {
    [CmdletBinding()]
    [OutputType("antv.chart.tooltip.crosshairs")]
    param(
        [Parameter()]
        [ValidateSet("x", "y", "cross")]
        [string]$Type,
        [Parameter()]
        [hashtable]$Style
    )

    end {
        $Crosshairs = @{
            type  = $Type
            style = $Style    
        }
        $Crosshairs.PSTypeNames.Insert(0, "antv.chart.tooltip.crosshairs") | Out-Null
        $Crosshairs
    }
}

function Add-DynamicParameter {
    param(
        [Parameter()]
        [hashtable[]]$Parameters
    )

    begin {
        # Set up the Run-Time Parameter Dictionary
        $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $false
        $AttributeCollection.Add($ParameterAttribute)
    }

    process {
        # Begin dynamic parameter definition
        foreach($Prm in $Parameters){
            $ParamName = $Prm.Name
            $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ParamName, $Prm.Type, $AttributeCollection)
            $RuntimeParameterDictionary.Add($ParamName, $RuntimeParameter)
        }
        # $ParameterAttribute.Position = 0
        # $ValidationValues = Get-CsOnlineTelephoneNumber -IsNotAssigned | Select-Object -ExpandProperty Id
        # $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($ValidationValues)
        # $AttributeCollection.Add($ValidateSetAttribute)
        # End Dynamic parameter definition
    }
    end {
        # When done building dynamic parameters, return
        return $RuntimeParameterDictionary
    }
}
