Return-Path: <linux-kernel-owner+w=401wt.eu-S1754078AbZIISYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbZIISYF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 14:24:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754067AbZIISYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 14:24:04 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52544 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879AbZIISYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 14:24:03 -0400
Date: Wed, 9 Sep 2009 19:23:40 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, utx@penguin.cz,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch for 2.6.31] zaurus c3000 aka spitz: fix resume
Message-ID: <20090909182340.GA5235@n2100.arm.linux.org.uk>
References: <20090909075024.GA1400@ucw.cz> <f17812d70909090737n4315d0cbh82c0a63e9222fdb5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f17812d70909090737n4315d0cbh82c0a63e9222fdb5@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 09, 2009 at 10:37:41PM +0800, Eric Miao wrote:
> On Wed, Sep 9, 2009 at 3:50 PM, Pavel Machek<pavel@ucw.cz> wrote:
> > Hi, Linus!
> >
> > Spitz resume was broken for year or likely two, and it would be very
> > nice to fix it for 2.6.31 release. One liner is below, and it really
> > can not harm. It already is in Eric's fix queue, so pulling that for
> > .31 should work, too.
> >
> 
> This should be sitting in rmk's git tree and I'm not sure if Russell
> has sent the pull request already.

It's just Pavel being his obnoxious impatient self...
