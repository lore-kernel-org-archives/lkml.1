Return-Path: <linux-kernel-owner+w=401wt.eu-S1758272AbXLGXKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758272AbXLGXKQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 18:10:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758147AbXLGXJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 18:09:57 -0500
Received: from smtp.cs.aau.dk ([130.225.194.6]:45927 "EHLO smtp.cs.aau.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758108AbXLGXJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 18:09:56 -0500
Subject: Re: programs vanish with 2.6.22+
From: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
To: Markus <M4rkusXXL@web.de>
Cc: linux-kernel@vger.kernel.org,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>
In-Reply-To: <200712072352.04454.M4rkusXXL@web.de>
References: <200712061906.42070.M4rkusXXL@web.de>
	 <200712071240.27838.M4rkusXXL@web.de>
	 <Pine.LNX.4.64.0712071252040.29411@axis700.grange>
	 <200712072352.04454.M4rkusXXL@web.de>
Content-Type: text/plain; charset=utf-8
Date: Sat, 08 Dec 2007 00:09:30 +0100
Message-Id: <1197068970.6557.3.camel@odie.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fre, 07 12 2007 kl. 23:52 +0100, skrev Markus:
> Well, now some windows vanished, but no additional messages were 
> produced by kernel. When somebody could tell what I exactly need to 
> do... would be nice.
> Or a hit, in what direction I should look. Because its really nasty to 
> not being able to use a current kernel.
> 
> I already rebuild the whole system, as suggested by the gentoo-devs, 
> without success.
> 
> I could also try to debug/strace/whatever the apps and wait for it to 
> disappear.
> 
> Just talk to me, I am not able to do this on my own...
> 
If you feel like you are able to tell whether a specific kernel version
is buggy or not, you might want to try to bisect it. See
Documentation/BUG-HUNTING in the sources, and please ask.


Simon Holm Thøgersen

