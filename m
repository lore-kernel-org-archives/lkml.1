Return-Path: <linux-kernel-owner+w=401wt.eu-S936342AbXJQD41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936342AbXJQD41 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 23:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758598AbXJQD4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 23:56:19 -0400
Received: from alnrmhc11.comcast.net ([204.127.225.91]:56326 "EHLO
	alnrmhc11.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbXJQD4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 23:56:18 -0400
Subject: Re: Boot Failure with 2.6.23-rc10
From: Chris Holvenstot <cholvenstot@comcast.net>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <47157C4B.2000502@googlemail.com>
References: <1192589191.6732.11.camel@localhost>
	 <47157C4B.2000502@googlemail.com>
Content-Type: text/plain
Date: Tue, 16 Oct 2007 23:00:10 -0500
Message-Id: <1192593610.7141.0.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you, that worked great.

Chris


On Wed, 2007-10-17 at 05:06 +0200, Gabriel C wrote:
> Chris Holvenstot wrote:
> > Greetings - 
> 
> Hi,
> 
> > 
> > This is likely something I am doing wrong (or stupid) but I have run
> > through the build process a couple of times with the same result.  
> > 
> > When booted, the following messages are displayed:
> > 
> > Linux  zimage kernel to big, try "make bzImage"
> > 
> > Error 28: Selected item can into fit into memory
> > 
> > I have tried the "make bzImage" and manually copied forward to /boot -
> > no joy.
> > 
> 
> If you use git just pull is already fixed if not get that patch :
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff_plain;h=7eebb9348655b55553d65fc7cb6cfad292d28dbb
> 
> 
> Regards,
> 
> Gabriel

