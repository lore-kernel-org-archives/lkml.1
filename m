Return-Path: <linux-kernel-owner+w=401wt.eu-S1757270AbYGOQsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270AbYGOQsh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 12:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753029AbYGOQs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 12:48:29 -0400
Received: from hpsmtp-eml19.kpnxchange.com ([213.75.38.84]:47666 "EHLO
	hpsmtp-eml19.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752960AbYGOQs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 12:48:29 -0400
From: Frans Pop <elendil@planet.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel, use it in more drivers.
Date: Tue, 15 Jul 2008 18:48:24 +0200
User-Agent: KMail/1.9.9
Cc: jeff@garzik.org, arjan@infradead.org, akpm@linux-foundation.org,
       dwmw2@infradead.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
References: <1216077806.27455.85.camel@shinybook.infradead.org> <alpine.LFD.1.10.0807150913590.3017@woody.linux-foundation.org> <alpine.LFD.1.10.0807150931010.3017@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807150931010.3017@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807151848.26026.elendil@planet.nl>
X-OriginalArrivalTime: 15 Jul 2008 16:48:26.0616 (UTC) FILETIME=[9A2EA780:01C8E69A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 July 2008, Linus Torvalds wrote:
> There are obviously all these kinds of _productive_ questions you can
> ask. But people seem to be mostly in an unproductive "Mommy, it hurts
> when I do something stupid" mode.

Of course, but the main reason I replied in the first place was because 
your "there are no real problems" attitude in this discussion was 
annoying me.

And even in your first reply to me you basically ignored that fact that at 
least one kernel packaging tool and one that is *part of the kernel tree 
itself* is now broken.

There *are* real problems and some of them *could* be solved by allowing 
firmware to be compiled into modules. Sure, other solutions are possible 
too and if I actually run into the problems I foresee with dpk-deb you 
can be certain I will try to help solve them.

But if you want to invite people to hold a productive discussion, it helps 
if you don't completely ignore their concerns out of hand.
