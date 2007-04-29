Return-Path: <linux-kernel-owner+w=401wt.eu-S1752906AbXD2WPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbXD2WPH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 18:15:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161497AbXD2WPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 18:15:07 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37369 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906AbXD2WPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 18:15:05 -0400
Date: Mon, 30 Apr 2007 00:15:02 +0200
From: Andi Kleen <andi@firstfloor.org>
To: David Miller <davem@davemloft.net>
Cc: andi@firstfloor.org, torvalds@linux-foundation.org, bunk@stusta.de,
       diegocg@gmail.com, cebbert@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.21
Message-ID: <20070429221502.GA714@one.firstfloor.org>
References: <20070429180909.GA30604@one.firstfloor.org> <20070429.130143.21926295.davem@davemloft.net> <20070429212643.GA32750@one.firstfloor.org> <20070429.144150.65190684.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070429.144150.65190684.davem@davemloft.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> BECAUSE EMAIL ENGAGES PEOPLE AND BUGZILLA DOES NOT!
> 
> Nobody looks at the bugzilla because there is too much junk in there
> to make the signal any useful to search for, there's simply too much
> noise.

That means just x.org doesn't have a working bugmaster setup.
Again a technical solution doesn't fix misorganization or missing people;
it just pushes some work humans are at to computers if you have the right structure

The normal bugzilla workflow is that some people categorize the bugs, 
ask the necessary questions and then figure out which developer
to assign it to. Then the developer doesn't end up with "too much noise"
but just a limited set of bugs to look at.

And the responsible developer then gets an email and looks at the bug.

This already happens to some limited fashion in kernel.org bugzilla:
I get bugs assigned occasionally and while it's slow I tend to look
at (near) all of them and try to improve things there.

If a single developer ends up with too many bugs this way or there
is nobody to assign a bug to or nobody processes the incoming bugs
then the project has a problem. Yes bugzilla doesn't work then 
if the project is not well organized.

But that's in no way different from what would happen with your
email sent to a mailing list if it had the same problem.

-Andi (who finds it a bit bizarre he has to explain the concept
of "things can get easier when some work is pushed to computers"
concept to a hacker) 

