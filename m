Return-Path: <linux-kernel-owner+w=401wt.eu-S1757357AbYD0HW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357AbYD0HW1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 03:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbYD0HWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 03:22:20 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34740
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752121AbYD0HWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 03:22:20 -0400
Date: Sun, 27 Apr 2008 00:22:16 -0700 (PDT)
Message-Id: <20080427.002216.165148751.davem@davemloft.net>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, rostedt@goodmis.org
Subject: Re: [patch] ftrace, v15
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080427071659.GA13036@elte.hu>
References: <20080427063019.GA23295@elte.hu>
	<20080426.233240.252075490.davem@davemloft.net>
	<20080427071659.GA13036@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Sun, 27 Apr 2008 09:16:59 +0200

> * David Miller <davem@davemloft.net> wrote:
> 
> > You're getting sloppier and sloppier each and every bogus pull request 
> > you send out this week Ingo.
> 
> this is not a pull request David ...
> 
> > What is all of this non-ftrace crap in the shortlog?
> 
> other changes in my tree ...

Regardless of what it is, I'm getting really sick and tired of how
you're doing development during this merge window and all of the
completely bogus and unreviewed changes you are inserting into the
tree at a freightening pace.

Someone posting a patch to LkML and YOU applying the patch to your
tree DOES NOT equal "reviewed"!

If nobody has had a chance to review the patch, too bad.

By jamming all of this stuff into Linus's tree, you are forcing poor
souls like myself and Andrew Morton to watch over you like a small
child.  And that is totally unfair to those of us who have our own
merging and development work to do.

The code gets reviewed first, not after it's in the tree already.

Your little "let's see how fast I can merge patches into the tree"
experiment is coming at an enormous cost.
