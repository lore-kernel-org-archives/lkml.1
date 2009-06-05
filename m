Return-Path: <linux-kernel-owner+w=401wt.eu-S1752258AbZFENTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258AbZFENTB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 09:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbZFENSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 09:18:54 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:50797 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbZFENSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 09:18:53 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Harald Welte <HaraldWelte@viatech.com>
Subject: Re: Linux 2.6.30-rc8 [also: VIA Support]
Date: Fri, 5 Jun 2009 08:18:42 -0500
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <200906050227.42295.lkml@morethan.org> <20090605103929.GE4421@prithivi.gnumonks.org>
In-Reply-To: <20090605103929.GE4421@prithivi.gnumonks.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906050818.44701.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri June 5 2009, Harald Welte wrote:
> Hi Michael,
> 
> On Fri, Jun 05, 2009 at 02:27:40AM -0500, Michael S. Zick wrote:
> 
> > > As a side note: The C7-M actually uses the same software interface as Intel CPU
> > > for doing the power transitions (ACPI Performance States).   Only very early C7
> > > models used the cpufreq/e_powersaver.c driver.
> > 
> > What is "very early C7 models" in terms of cpuid results?
> 
> I've inquired about that.
> 
> Looking at he code, the driver only seems to checking for a minimum CPUID
> value, but doesn't contain a maximum.
> 

That is the way I read it also.

Mike
> Regards,


