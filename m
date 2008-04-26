Return-Path: <linux-kernel-owner+w=401wt.eu-S1754616AbYDZL0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbYDZL0x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 07:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbYDZL0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 07:26:45 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:60516 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333AbYDZL0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 07:26:45 -0400
Date: Sat, 26 Apr 2008 13:27:17 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: If you want me to quit I will quit
Message-ID: <20080426112717.GA23248@uranus.ravnborg.org>
References: <1209190455.14173.13.camel@brick> <20080426110044.GB2252@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080426110044.GB2252@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian.

> Why do other people get over 100 checkpatch fixes into the tree at once 
> or Linus applies patches directly bypassing the maintainers (like the 
> one you sent just before [3], which I've also already sent before [4]) 
> but my patches bitrot forever?

The patches you submit touches all parts of the kernel tree.
And you do a good job in finding the relevant receivers.

To me you are partly in the saem situation as Andrew in that
you handle a great deal of patches touching a lot of different
subsystems.
We all know that the patch acceptance ratio differ a lot between
the different maintainers and the way Andrew deals with this
seems quite effective.
After enough tries Andrew just submit the pacthes himself direct
to Linus. But almost never without trying to get the relevant
Maintainer to take it first.
So in your position I would keep all patches in
a place so they can be sucked into -next and regular spam
the relevant amintainers with their patches.
When the merge window opens then submit the rest to Linus
with a noe that they have been sent to Maintainers without
any feedback previously.

This is not far away from what you do now and should not create
that big frustrations (I hope).

	Sam
