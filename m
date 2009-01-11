Return-Path: <linux-kernel-owner+w=401wt.eu-S1751966AbZAKFnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966AbZAKFnt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 00:43:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751022AbZAKFnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 00:43:41 -0500
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:56335 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbZAKFnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 00:43:40 -0500
Date: Sat, 10 Jan 2009 21:43:27 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell2.speakeasy.net
To: Richard Purdie <rpurdie@rpsys.net>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Guennadi Liakhovetski <lg@denx.de>,
       linuxppc-dev@ozlabs.org
Subject: Re: [GIT PULL] LED updates for 2.6.29
In-Reply-To: <1231633983.5330.32.camel@dax.rpnet.com>
Message-ID: <Pine.LNX.4.58.0901102138300.1626@shell2.speakeasy.net>
References: <1231500186.5317.9.camel@dax.rpnet.com> 
 <Pine.LNX.4.64.0901091231310.22972@t2.domain.actdsltmp> 
 <1231543199.5317.63.camel@dax.rpnet.com>  <Pine.LNX.4.58.0901100428230.1626@shell2.speakeasy.net>
 <1231633983.5330.32.camel@dax.rpnet.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Jan 2009, Richard Purdie wrote:
> On Sat, 2009-01-10 at 04:31 -0800, Trent Piepho wrote:
> > The LED tree makes more sense for what's left I think.  There was a
> > openfirmware gpio patch, but that's already gone in.  What's left only
> > touches led files and the device tree binding docs.
> >
> > AFAIK, there were no objections to the patches left.
>
> Ok, these are now queued in the LED tree:
>
> http://git.o-hand.com/cgit.cgi/linux-rpurdie-leds/log/
>
> I did merge the last three patches in one and make some changes to deal
> with some other outstanding issues. Let me know ASAP if there are any
> problems.

Since the last patch looks like it's just my three patches folded into one,
shouldn't I be listed as the author and the primary signed off by?
