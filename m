Return-Path: <linux-kernel-owner+w=401wt.eu-S1760054AbXJLJ60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760054AbXJLJ60 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 05:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756139AbXJLJ6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 05:58:16 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:37162 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754080AbXJLJ6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 05:58:15 -0400
Message-ID: <470F4535.3050004@free.fr>
Date: Fri, 12 Oct 2007 11:58:13 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: linux-acpi@vger.kernel.org
CC: linux-kernel@vger.kernel.org, robert.moore@intel.com, len.brown@intel.com
Subject: Re: halt does not shut the system down
References: <470A58AF.9080402@free.fr> <470C9731.6030200@free.fr>
In-Reply-To: <470C9731.6030200@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John Sigler wrote:

> When I run 'halt' the kernel prints:
>
> Halting.
> Shutdown: hdc
> ACPI: PCI interrupt for device 0000:01:05.0 disabled
> ACPI: PCI interrupt for device 0000:01:04.0 disabled
> ACPI: PCI interrupt for device 0000:01:03.0 disabled
> ACPI: PCI interrupt for device 0000:01:02.0 disabled
> Power down.
> acpi_power_off called
>
> But the system does not shut down. (The fans keep spinning, the LEDs 
> keep shining, the LCD keeps displaying.) Basically, the motherboard is 
> still providing power to every component, as if the power supply had 
> refused to stop.
>
> http://linux.kernel.free.fr/halt/config-2.6.22.1-rt9
> http://linux.kernel.free.fr/halt/acpidump.txt
> http://linux.kernel.free.fr/halt/dmesg.txt
> http://linux.kernel.free.fr/halt/halt.txt
> http://linux.kernel.free.fr/halt/lspci.txt

Is there something else I can provide that might help in identifying
the problem?

Regards.
