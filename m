Return-Path: <linux-kernel-owner+w=401wt.eu-S1752872AbZFDRuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872AbZFDRuh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 13:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbZFDRuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 13:50:07 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:58669 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbZFDRuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 13:50:06 -0400
Date: Thu, 4 Jun 2009 19:45:46 +0200
From: Harald Welte <HaraldWelte@viatech.com>
To: "Michael S. Zick" <lkml@morethan.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.30-rc8 [also: VIA Support]
Message-ID: <20090604174546.GC9823@prithivi.gnumonks.org>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <200906040958.46018.lkml@morethan.org> <alpine.LFD.2.01.0906040817090.4880@localhost.localdomain> <200906041037.50461.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906041037.50461.lkml@morethan.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Thu, Jun 04, 2009 at 10:37:46AM -0500, Michael S. Zick wrote:

> On the Everex Cloudbook (C7-M/CX700) I have gotten a record
> of 4h45 minutes of up-time on some, locally patched, builds.
> The same is reported on other Everex Cloudbooks.
>
> On the Sylvania gBook (also C7-M/CX700) the user reports
> 10s of minutes as their record up-time.

It seems like I need to obtain one of those.  I'll see if VIA can help, but
it might help if you have a known-bad unit that I could get for debugging.

Just to re-confirm: Those kind of problems are you seeing with any kernel, or
only specifically with later (2.6.30-rcX) kernels?  If it's not a regression,
then I think there is no impact of the bug on the 2.6.30 release.

> H.W. got hold of one of the companies demo-boards but I
> haven't heard back from him yet on his experiences.

I don't really have your test case.  I've personally been running a CX700 based
mainboard (some EPIA board) as my digital video recording device for > one year
here, without any lock ups at all.  I have not been running any recent kernels
on that system, though.

Regards,
-- 
- Harald Welte <HaraldWelte@viatech.com>	    http://linux.via.com.tw/
============================================================================
VIA Free and Open Source Software Liaison
