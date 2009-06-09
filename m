Return-Path: <linux-kernel-owner+w=401wt.eu-S1757263AbZFIQX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263AbZFIQX4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 12:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755400AbZFIQXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 12:23:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59226 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754495AbZFIQXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 12:23:48 -0400
Date: Tue, 9 Jun 2009 12:22:55 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: lkml@morethan.org
Cc: Harald Welte <HaraldWelte@viatech.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 1/2] CPUFREQ: Enable acpi-cpufreq driver for VIA/Centaur
 CPUs
Message-ID: <20090609122255.147b680a@dhcp-100-2-144.bos.redhat.com>
In-Reply-To: <200906090726.14187.lkml@morethan.org>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain>
	<alpine.LFD.2.01.0906081128410.6847@localhost.localdomain>
	<20090609021551.GG4455@prithivi.gnumonks.org>
	<200906090726.14187.lkml@morethan.org>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Jun 2009 07:26:11 -0500
"Michael S. Zick" <lkml@morethan.org> wrote:

> > Sounds fine with me. But what I would definitely suggest merging before 2.6.30
> > is the marking e_powersaver EXPERIMENTAL + DANGEROUS patch.
> >  
> 
> As posted somewhere in this thread,
> the acpi-cpufreq controller appears to work on my machine in initial tests.

It works great on the Samsung NC20 with an x86_64 kernel.
