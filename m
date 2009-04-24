Return-Path: <linux-kernel-owner+w=401wt.eu-S1754379AbZDXDf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379AbZDXDf5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 23:35:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751432AbZDXDfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 23:35:48 -0400
Received: from vms173007pub.verizon.net ([206.46.173.7]:45005 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbZDXDfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 23:35:47 -0400
Date: Thu, 23 Apr 2009 23:35:39 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Ross Alexander <Ross.Alexander@EU.NEC.COM>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       cpufreq@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: ACPI / powernow-k8 problems with M4A78T-E (AM3) and 2.6.30-rc3
In-reply-to: <alpine.LFD.2.00.0904231616480.15843@localhost.localdomain>
Message-id: <alpine.LFD.2.00.0904232334430.15843@localhost.localdomain>
References: <F632EDDF1017D445AE61401A3E974CC082EA4131CE@EUEXCLU01.EU.NEC.COM>
 <alpine.LFD.2.00.0904231616480.15843@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 23 Apr 2009, Ross Alexander wrote:
> 
> > With BIOS version 0801 the powernow-k8 faulting.
> > 
> > ------------[ cut here ]------------
> > WARNING: at arch/x86/kernel/cpu/cpufreq/powernow-k8.c:1257 powernowk8_cpu_init+0
> > x4e0/0xd3f()
> > Hardware name: System Product Name
> > [Firmware Bug]: powernow-k8: Your BIOS does not provide ACPI _PSS objects in a w
> > ay that Linux understands. Please report this to the Linux ACPI maintainers and
> > complain to your BIOS vendor.
> 
> If you attach the output from acpidump to a new bugzilla entry,
> 
> http://bugzilla.kernel.org/enter_bug.cgi?product=ACPI

Turns out that the report already exists.
Please attach the output from acpidump here:

http://bugzilla.kernel.org/show_bug.cgi?id=13146

thanks,
-Len Brown, Intel Open Source Technology Center

