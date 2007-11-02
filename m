Return-Path: <linux-kernel-owner+w=401wt.eu-S1757830AbXKBRdE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757830AbXKBRdE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 13:33:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755916AbXKBRcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 13:32:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54115 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754644AbXKBRcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 13:32:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Meyer <thomas@m3y3r.de>
Subject: Re: [regression] v2.6.24-rc1-497-gb1d08ac: kde battery icon gone
Date: Fri, 2 Nov 2007 18:49:50 +0100
User-Agent: KMail/1.9.5
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alexey Starikovskiy <aystarik@gmail.com>
References: <472B5C01.7090508@m3y3r.de>
In-Reply-To: <472B5C01.7090508@m3y3r.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711021849.50716.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 2 November 2007 18:18, Thomas Meyer wrote:
> i just wanted to report this:
> 
> in v2.6.24-rc1-497-gb1d08ac the kde battery icon is no longer displayed.

Appropriate CCs added.

> with 2.6.23 shows the battery icon.
> 
> current config:
> 
> grep -i acpi .config
> # Power management options (ACPI, APM)
> CONFIG_ACPI=y
> CONFIG_ACPI_SLEEP=y
> # CONFIG_ACPI_PROCFS is not set
> CONFIG_ACPI_PROC_EVENT=y
> CONFIG_ACPI_AC=m
> CONFIG_ACPI_BATTERY=m
> CONFIG_ACPI_BUTTON=m
> CONFIG_ACPI_VIDEO=m
> CONFIG_ACPI_FAN=m
> CONFIG_ACPI_DOCK=m
> CONFIG_ACPI_BAY=m
> CONFIG_ACPI_PROCESSOR=m
> CONFIG_ACPI_HOTPLUG_CPU=y
> CONFIG_ACPI_THERMAL=m
> # CONFIG_ACPI_ASUS is not set
> # CONFIG_ACPI_TOSHIBA is not set
> CONFIG_ACPI_BLACKLIST_YEAR=0
> CONFIG_ACPI_DEBUG=y
> # CONFIG_ACPI_DEBUG_FUNC_TRACE is not set
> CONFIG_ACPI_EC=y
> CONFIG_ACPI_POWER=y
> CONFIG_ACPI_SYSTEM=y
> CONFIG_ACPI_CONTAINER=m
> CONFIG_ACPI_SBS=m
> CONFIG_X86_ACPI_CPUFREQ=m
> # CONFIG_X86_ACPI_CPUFREQ_PROC_INTF is not set
> CONFIG_HOTPLUG_PCI_ACPI=m
> # CONFIG_HOTPLUG_PCI_ACPI_IBM is not set
> CONFIG_PNPACPI=y
> # CONFIG_THINKPAD_ACPI is not set
> CONFIG_ATA_ACPI=y
> # CONFIG_PATA_ACPI is not set
> 
> -
