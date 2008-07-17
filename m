Return-Path: <linux-kernel-owner+w=401wt.eu-S1758959AbYGQRZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758959AbYGQRZY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 13:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757104AbYGQRZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 13:25:10 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:52125 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756112AbYGQRZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 13:25:09 -0400
Date: Thu, 17 Jul 2008 19:25:07 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Stoyan Gaydarov <stoyboyker@gmail.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, gorcunov@gmail.com,
       akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: From 2.4 to 2.6 to 2.7?
In-Reply-To: <alpine.LNX.1.10.0807150851040.13215@fbirervta.pbzchgretzou.qr>
Message-ID: <alpine.LNX.1.10.0807171920010.12734@fbirervta.pbzchgretzou.qr>
References: <6d291e080807141910m573b29b2t753ea7c4db09902d@mail.gmail.com>  <alpine.LFD.1.10.0807141914280.3017@woody.linux-foundation.org> <6d291e080807141931g3080c94cic94f503c1a18523b@mail.gmail.com> <alpine.LFD.1.10.0807141939410.3017@woody.linux-foundation.org>
 <alpine.LNX.1.10.0807150851040.13215@fbirervta.pbzchgretzou.qr>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 2008-07-15 09:49, Jan Engelhardt wrote:
>Sometime on Tuesday 2008-07-15, Linus Torvalds wrote:
>
>>We don't do releases based on "features" any more, so why should we do 
>>version _numbering_ based on "features"?
>>
>>For example, I don't see any individual feature that would merit a jump 
>>from 2.x to 3.x or even from 2.6.x to 2.8.x. So maybe those version 
>>jumps should be done by a time-based model too - matching how we 
>>actually do releases anyway.
>
>Maybe not individual feature, but as a whole. We probably should have 
>jumped when the new model was introduced. Ok, that did not happen, but 
>over time, the kernel's abilities increased and then sometime, there 
>was a release where you would say (as of today) "yes, that kernel back 
>there has been a really good one" where a version jump would have been 
>warranted at the same time. For me, these are 2.6.18, .22, .23 or .25 
>(pick one). However, there also needs to be a bit of time between minor 
>number bumps, so if 2.6.18 were 2.7.0, 2.6.25 would be the earliest to 
>qualify for a 2.8.0.

Continuing on that thought..

Incrementing the minor number once every 6 to 8 releases or so
(resetting the micro number to 0 of course) would nicely mark a group
of featureful kernels.

