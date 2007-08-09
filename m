Return-Path: <linux-kernel-owner+w=401wt.eu-S938842AbXHIGKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938842AbXHIGKN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 02:10:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754917AbXHIGKB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 02:10:01 -0400
Received: from mail.gmx.net ([213.165.64.20]:34178 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754688AbXHIGKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 02:10:00 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/qNaU8jQvqjevP5qKRXFUaJ5+vXrugE6hoR4LCan
	TBHPTzRg23RkC1
Date: Thu, 9 Aug 2007 08:09:56 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Oncaphillis <oncaphillis@snafu.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: UART misbehaves under Linkstation/KuroBoxHG
In-Reply-To: <46BA59FA.7080706@snafu.de>
Message-ID: <Pine.LNX.4.60.0708090805220.3812@poirot.grange>
References: <46B9CE82.1050000@snafu.de> <Pine.LNX.4.60.0708082219520.6767@poirot.grange>
 <46BA320E.1030608@snafu.de> <Pine.LNX.4.60.0708082323420.6767@poirot.grange>
 <46BA3DF5.4050201@snafu.de> <Pine.LNX.4.60.0708090041160.6767@poirot.grange>
 <46BA59FA.7080706@snafu.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Aug 2007, Oncaphillis wrote:

>  Removing the getty from initd did the trick.
> 
>  And you're right AVR is disabled by the kernel
>  found the code in ./arch/powerpc/platforms/embedded6xx/ls_uart.c

Good. For the future, with any (kernel / userspace / software / hardware / 
weather / ...) linkstation/kurobox related questions you are welcome to 
use LinkStation_General@yahoogroups.com or the #linkstationwiki channel on 
irc.freenode.net, or the forums on the http://linkstationwiki.net/.

Good luck
Guennadi
---
Guennadi Liakhovetski
