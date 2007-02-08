Return-Path: <linux-kernel-owner+w=401wt.eu-S933356AbXBHDCG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933356AbXBHDCG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 22:02:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933359AbXBHDCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 22:02:06 -0500
Received: from smtp.osdl.org ([65.172.181.24]:51918 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933356AbXBHDCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 22:02:03 -0500
Date: Wed, 7 Feb 2007 19:01:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Marcin Juszkiewicz <openembedded@hrw.one.pl>
Subject: Re: Git backlight subsystem tree
Message-Id: <20070207190153.4acd6006.akpm@linux-foundation.org>
In-Reply-To: <1170901826.5859.2.camel@localhost.localdomain>
References: <1170901826.5859.2.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Feb 2007 02:30:26 +0000 Richard Purdie <rpurdie@rpsys.net> wrote:

> I'm thinking of more officially volunteering to maintain the Linux
> backlight class/subsystem and have been trying to sort out the various
> pending patches. I've made a backlight tree available as:
> 
> http://git.o-hand.com/?p=linux-rpurdie-backlight;a=shortlog;h=for-mm
> 
> (or git://git.o-hand.com/linux-rpurdie-backlight)
> 
> This has a for-mm branch containing the backlight patches I've sorted
> out so far. I still have some others left to deal with which are
> probably more invasive and will need discussion and testing which I'll
> send some mails about soon.

No probs,  I added git://git.o-hand.com/linux-rpurdie-backlight#for-mm to
-mm as git-backlight.patch.

> I'm planning to setup an LED drivers/class tree too, I have a couple of
> pending patches for that.

ooh, patches!
