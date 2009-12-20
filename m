Return-Path: <linux-kernel-owner+w=401wt.eu-S1755485AbZLTRUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485AbZLTRUg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 12:20:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201AbZLTRUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 12:20:34 -0500
Received: from mail.gmx.net ([213.165.64.20]:39900 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751946AbZLTRUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 12:20:33 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX19p0gMTa19pMn1+/Tof2kBjNHy218wzTZijJ1iag7
	IjLLSaRDNyGs2c
Date: Sun, 20 Dec 2009 18:20:48 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
       Ian Molton <ian@mnementh.co.uk>
Subject: Re: [PATCH/RFC] tmio_mmc: keep card-detect interrupts enabled
In-Reply-To: <20091217131239.0dfd5534.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0912201807370.14323@axis700.grange>
References: <Pine.LNX.4.64.0911061127240.4389@axis700.grange>
 <c09aa50a0911090242l35d0dfb2vec0cdeff8b86d33e@mail.gmail.com>
 <Pine.LNX.4.64.0911091530030.4289@axis700.grange>
 <c09aa50a0911091218i681449e0r5cb96b9db3e0def6@mail.gmail.com>
 <Pine.LNX.4.64.0911092134440.4289@axis700.grange>
 <c09aa50a0911091736k27d66483t9012e296bfbf578a@mail.gmail.com>
 <Pine.LNX.4.64.0911282002490.3696@axis700.grange>
 <Pine.LNX.4.64.0912162223170.5283@axis700.grange>
 <Pine.LNX.4.64.0912172113510.5991@axis700.grange>
 <20091217131239.0dfd5534.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew

On Thu, 17 Dec 2009, Andrew Morton wrote:

> On Thu, 17 Dec 2009 21:25:52 +0100 (CET)
> Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> 
> > I originally submitted this [1] patch on the 6th of November, then 
> > accidentally the MMC list got dropped from CC and the discussion moved to 
> > another irrelevant list, Ian's last reply is at [2]. Unfortunately, Ian 
> > hasn't replied to my reminders since then, and I don't see this patch 
> > anywhere upstream. Is there any way we could get it into 2.6.33?
> 
> Please redo and retest it against curent mainline and do a full resend.

As I tried to re-test, I found out, that some other patches from Ian are 
currently missing in the mainline, so, even though this my specific patch 
doesn't depend on those changes, unfortunately, I currently cannot test 
tmio_mmc on sh. Will resubmit as soon as those patches hit mainline.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
