Return-Path: <linux-kernel-owner+w=401wt.eu-S967984AbXEHFsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967984AbXEHFsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 01:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967971AbXEHFsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 01:48:53 -0400
Received: from ns2.suse.de ([195.135.220.15]:48576 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967934AbXEHFsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 01:48:53 -0400
Date: Mon, 7 May 2007 22:49:58 -0700
From: Greg KH <gregkh@suse.de>
To: Dmitry Torokhov <dtor@insightbb.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [git pull] More input updates for post-2.6.21
Message-ID: <20070508054958.GA29372@suse.de>
References: <200705080146.14911.dtor@insightbb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705080146.14911.dtor@insightbb.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 01:46:14AM -0400, Dmitry Torokhov wrote:
> Hi Linus,
> 
> Please consider pulling from:
> 
> ?? ?? ?? ?? git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git
> 
> or
> ?? ?? ?? ?? master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git
> 
> to receive more updates for input subsystem. You will get yet another
> fix for i8042 AUX detection, bunch of sparse warnings fixed and
> USB input devices moved into drivers/input to keep all input devices
> together in menuconfig and friends.

Yes, I have no objection to this move at all, thanks Dmitry for doing
it.

greg k-h
