Return-Path: <linux-kernel-owner+w=401wt.eu-S1757164AbYLKUM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164AbYLKUM4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 15:12:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756229AbYLKUMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 15:12:47 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58678 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756227AbYLKUMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 15:12:46 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.28-rc8
Date: Thu, 11 Dec 2008 21:12:05 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.00.0812101651130.3340@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0812101651130.3340@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812112112.05936.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 11 of December 2008, Linus Torvalds wrote:
> 
> Nothing overly exciting here. Lots of small things, mostly in drivers 
> (with some defconfig updates for m68k and mips making the diffs bigger). 
> 
> There's some uncomfortably big changes to the intel DRI code, but most of 
> that is all about fixes to the new i916 "GEM" code that is only used by 
> development X servers, and is a new feature, so it shouldn't be able to 
> cause regressions.
> 
> Perhaps more interesting is simply the release scheduling issue. I'm 
> getting slowly ready to do a real 2.6.28, but I don't think anybody really 
> wants the merge window to be around the holidays. So the question is 
> really whether to 
> 
>  (a) just make the -rc's go on a few more weeks, and do 2.6.28 after xmas
> 
>      I like this, because alledgely people are debugging things, and we'd 
>      get a more stable 2.6.28.
> 
> or
> 
>  (b) release in a week or two, but just allow for possibly extending the 
>      merge window due to people being drunk on eggnog..
> 
>      I like this because let's face it, we get more and better bug 
>      information after releases, and everything _should_ be ready for 
>      merging *before* the merge window anyway.

FWIW, I vote for this one.

Thanks,
Rafael
