Return-Path: <linux-kernel-owner+w=401wt.eu-S1756691AbXD0ROU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691AbXD0ROU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 13:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756686AbXD0ROT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 13:14:19 -0400
Received: from hobbit.corpit.ru ([81.13.94.6]:23962 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756689AbXD0ROQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 13:14:16 -0400
Message-ID: <46322F63.9000604@msgid.tls.msk.ru>
Date: Fri, 27 Apr 2007 21:14:11 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org>	<20070426040806.GJ3468@stusta.de> <20070426125802.GL3468@stusta.de>	<alpine.LFD.0.98.0704260828550.9964@woody.linux-foundation.org>	<20070426165950.GO3468@stusta.de> <m3d51rhtid.fsf@maximus.localdomain>
In-Reply-To: <m3d51rhtid.fsf@maximus.localdomain>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
[]
> We've got stable series.
> With KNOWN_PROBLEMS information, sysadmins can decide if they can
> safely upgrade to .0 or if they have to wait for .123. Pressing
> the responsible people to fix the problems in .123 (would) help
> it greatly.

For how long you plan to maintain 2.6.x.y -stable series for each
2.6.x release?  The thing is that tehere will probably be NO
.123 "revision" (with maybe the exception of 2.6.16, thanks to
Adrian again).  The end result is that there will be just no stable
kernels *at all*. because when the next 2.6.x will start looking
more or less useful due to 2.6.x.y series, there will be new 2.6.x+1,
and work with 2.6.x stops...

It's not the case currently, but this way ("let's fix the bugs
in 2.6.x.y -stable series, don't bother releasing 2.6.x in a good
shape"), we can finally come to the above situation...

/mjt
