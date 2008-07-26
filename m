Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbYGZE3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbYGZE3i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 00:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751230AbYGZE3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 00:29:31 -0400
Received: from gate.crashing.org ([63.228.1.57]:51600 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182AbYGZE3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 00:29:31 -0400
Subject: Re: [git pull] Please pull from powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       akpm <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0807251734030.4188@nehalem.linux-foundation.org>
References: <1217027473.11188.120.camel@pasglop>
	 <alpine.LFD.1.10.0807251734030.4188@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Date: Sat, 26 Jul 2008 14:28:51 +1000
Message-Id: <1217046531.11188.126.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-25 at 17:38 -0700, Linus Torvalds wrote:
> 
> On Sat, 26 Jul 2008, Benjamin Herrenschmidt wrote:
> > 
> > Please pull from:
> > ﻿
> > ﻿git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge
> 
> What odd character do you have there before the 'git://' and why?

Hrm... no idea... must be some weirdo evolution thing...

> It cuts-and-pastes into some whitespace that isn't space, and that the 
> shell thus makes part of that word when parsing. It seems to be U+FEFF, 
> which is "zero-width non-break space", but what the heck is the point of 
> that kind of garbage in email?

No idea how it got there.

> Is this some new way for Evolution to screw up?

Quite possibly. I'll do some tests to see if I can reproduce locally...
it could be the result of a key combo that leaves that in the mail but
isn't visible... weird.

Sorry about that,

Cheers,
Ben.


