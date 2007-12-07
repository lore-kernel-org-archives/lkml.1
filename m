Return-Path: <linux-kernel-owner+w=401wt.eu-S1756687AbXLGWyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687AbXLGWyr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 17:54:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755772AbXLGWyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 17:54:36 -0500
Received: from fmmailgate01.web.de ([217.72.192.221]:60008 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169AbXLGWyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 17:54:35 -0500
From: Markus <M4rkusXXL@web.de>
To: linux-kernel@vger.kernel.org
Subject: Re: programs vanish with 2.6.22+
Date: Fri, 7 Dec 2007 23:52:04 +0100
User-Agent: KMail/1.9.7
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <200712061906.42070.M4rkusXXL@web.de> <200712071240.27838.M4rkusXXL@web.de> <Pine.LNX.4.64.0712071252040.29411@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0712071252040.29411@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712072352.04454.M4rkusXXL@web.de>
X-Provags-ID: V01U2FsdGVkX18gTsFP2h5TZ7oMxWpRO78az1IzPD1h+A+995NP
	f6ERaFx37cymJcbMm56EzmGTz++maJEex7VQx4j62x3WhriX+/
	vu8LDkq34=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, now some windows vanished, but no additional messages were 
produced by kernel. When somebody could tell what I exactly need to 
do... would be nice.
Or a hit, in what direction I should look. Because its really nasty to 
not being able to use a current kernel.

I already rebuild the whole system, as suggested by the gentoo-devs, 
without success.

I could also try to debug/strace/whatever the apps and wait for it to 
disappear.

Just talk to me, I am not able to do this on my own...


Markus

> On Fri, 7 Dec 2007, Markus wrote:
> 
> > Hi again!
> > 
> > The memtest ran 14 passes (~10h) without an error.
> > 
> > I now have a 2.6.24-rc4 with some debug-options turned on, waiting 
for 
> > something to happen... can I just leave it untill a window 
disappears 
> > or do I need to manually enable something or run some user-space 
app?!
> 
> It depends - different options have it differently. Most simple ones 
are 
> just compile-time, so, you don't have to enable them. Look in "help" 
for 
> respective debug-options.
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski
> 


