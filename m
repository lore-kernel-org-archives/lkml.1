Return-Path: <linux-kernel-owner+w=401wt.eu-S1758094AbZFIQpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094AbZFIQpk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 12:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758061AbZFIQp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 12:45:26 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:59207 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758229AbZFIQpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 12:45:25 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [PATCH 1/2] CPUFREQ: Enable acpi-cpufreq driver for VIA/Centaur CPUs
Date: Tue, 9 Jun 2009 11:45:19 -0500
User-Agent: KMail/1.9.9
Cc: Harald Welte <HaraldWelte@viatech.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <200906090726.14187.lkml@morethan.org> <20090609122255.147b680a@dhcp-100-2-144.bos.redhat.com>
In-Reply-To: <20090609122255.147b680a@dhcp-100-2-144.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906091145.22959.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue June 9 2009, Chuck Ebbert wrote:
> On Tue, 9 Jun 2009 07:26:11 -0500
> "Michael S. Zick" <lkml@morethan.org> wrote:
> 
> > > Sounds fine with me. But what I would definitely suggest merging before 2.6.30
> > > is the marking e_powersaver EXPERIMENTAL + DANGEROUS patch.
> > >  
> > 
> > As posted somewhere in this thread,
> > the acpi-cpufreq controller appears to work on my machine in initial tests.
> 
> It works great on the Samsung NC20 with an x86_64 kernel.
>

For non-NetBook aware readers, that means the:
VIA Nano U2250 processor with the VX800 system chipset.

Mike

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


