Return-Path: <linux-kernel-owner+w=401wt.eu-S1752683AbXJHEUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683AbXJHEUZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 00:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750778AbXJHEUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 00:20:11 -0400
Received: from wx-out-0506.google.com ([66.249.82.239]:29279 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbXJHEUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 00:20:09 -0400
Message-ID: <47099628.2050108@gmail.com>
Date: Sun, 07 Oct 2007 23:30:00 -0300
From: Hernan G Solari <hgsolari@gmail.com>
Reply-To: hgsolari@gmail.com
Organization: Universidad de Buenos Aires
User-Agent: Icedove 1.5.0.12 (X11/20070606)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux acpi <linux-acpi@vger.kernel.org>
Subject: Re: Serial ATA does not find partitions (Hitachi HD, new? ATI controller)
 where old SATA works
References: <46FC4384.7080607@df.uba.ar> <46FCCD57.2020507@gmail.com> <47014740.5080002@df.uba.ar> <4701EA71.2000609@gmail.com> <470220FE.2090506@gmail.com> <47044C6C.5030905@gmail.com> <47083555.2060605@gmail.com> <470981EE.30103@gmail.com>
In-Reply-To: <470981EE.30103@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Hmmm... and the kernel freezes after this?  libata driver isn't
> initialized yet.  I don't think libata has anything to do with here.
>
>   
as I told you, the ATA problem was with the 2.6.22 version of the kernel
and is not longer related to the freeze with kernel 2.6.23-rc8  I asked 
whether you wanted to see the ATA problem in that kernel or the present 
crash.

> Options: I can compile the 2.6.22 kernel to get the reported problem
>       or try to debug the problem in 2.6.22.8 or something else it
>        fits the kernel-team.

was my offer.

As you did not answer that point (you answered other points) I thought 
it was useless to debug a problem that is not longer there. I still 
thing that way.
The booting is apparently allocating port services at the  point of 
freezing but not too close of the disk driver, that much I  knew.

regards
                Hernan




-- 
Hernán Gustavo Solari, solari@df.uba.ar, http://www.df.uba.ar/~solari


