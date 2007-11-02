Return-Path: <linux-kernel-owner+w=401wt.eu-S1758690AbXKBRTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690AbXKBRTW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 13:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757141AbXKBRTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 13:19:08 -0400
Received: from www17.your-server.de ([213.133.104.17]:42365 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755335AbXKBRTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 13:19:06 -0400
Message-ID: <472B5C01.7090508@m3y3r.de>
Date: Fri, 02 Nov 2007 18:18:57 +0100
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [regression] v2.6.24-rc1-497-gb1d08ac: kde battery icon gone
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

i just wanted to report this:

in v2.6.24-rc1-497-gb1d08ac the kde battery icon is no longer displayed.

with 2.6.23 shows the battery icon.

current config:

grep -i acpi .config
# Power management options (ACPI, APM)
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=m
CONFIG_ACPI_BATTERY=m
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=m
CONFIG_ACPI_DOCK=m
CONFIG_ACPI_BAY=m
CONFIG_ACPI_PROCESSOR=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=m
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_DEBUG=y
# CONFIG_ACPI_DEBUG_FUNC_TRACE is not set
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_ACPI_CONTAINER=m
CONFIG_ACPI_SBS=m
CONFIG_X86_ACPI_CPUFREQ=m
# CONFIG_X86_ACPI_CPUFREQ_PROC_INTF is not set
CONFIG_HOTPLUG_PCI_ACPI=m
# CONFIG_HOTPLUG_PCI_ACPI_IBM is not set
CONFIG_PNPACPI=y
# CONFIG_THINKPAD_ACPI is not set
CONFIG_ATA_ACPI=y
# CONFIG_PATA_ACPI is not set

