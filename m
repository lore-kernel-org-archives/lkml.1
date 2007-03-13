Return-Path: <linux-kernel-owner+w=401wt.eu-S1753197AbXCMJ6I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197AbXCMJ6I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 05:58:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753202AbXCMJ5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 05:57:30 -0400
Received: from lnx130.hrz.tu-darmstadt.de ([130.83.174.24]:40971 "EHLO
	lnx130.hrz.tu-darmstadt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753201AbXCMJ5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 05:57:18 -0400
From: ST <st@iss.tu-darmstadt.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Gigabyte GA-M57SLI-S4 (the linuxbios compatible version) problems
Date: Tue, 13 Mar 2007 10:57:08 +0100
User-Agent: KMail/1.9.5
References: <200703121210.15812.st@iss.tu-darmstadt.de> <200703122217.18987.ioe-lkml@rameria.de>
In-Reply-To: <200703122217.18987.ioe-lkml@rameria.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703131057.09559.st@iss.tu-darmstadt.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo
> That seem to be no hardware failure.
> It's the same here. But with the recent bigiron-kernel
> from Ubuntu "edgy eft" (Ubuntu 2.6.17-11.35-server-bigiron).
Thanks for your answer. Since this board has linuxbios support and i plan to 
put it on this board, there has been a post which tells the right boot 
parameters:

apic=debug acpi_dbg_level=0xffffffff pci=noacpi,routeirq 
snd-hda-intel.enable_msi=1

I guess the "pci=noacpi,routeirq" makes the difference, but i haven't tried 
yet myself.

ST
