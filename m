Return-Path: <linux-kernel-owner+w=401wt.eu-S1031150AbXDQQWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031150AbXDQQWc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 12:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031151AbXDQQWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 12:22:32 -0400
Received: from keil-draco.com ([216.193.185.50]:50378 "EHLO mail"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1031150AbXDQQWb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 12:22:31 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Tomasz =?utf-8?q?K=C5=82oczko?= <kloczek@rudy.mif.pg.gda.pl>
Subject: Re: ZFS with Linux: An Open Plea
Date: Tue, 17 Apr 2007 12:22:19 -0400
User-Agent: KMail/1.9.6
Cc: Theodore Tso <tytso@mit.edu>, "David R. Litwin" <presently42@gmail.com>,
       linux-kernel@vger.kernel.org
References: <op.tqw1g6n0ftfxs2@localhost.localdomain> <20070417131045.GB18373@thunk.org> <Pine.BSO.4.63.0704171527150.11088@rudy.mif.pg.gda.pl>
In-Reply-To: <Pine.BSO.4.63.0704171527150.11088@rudy.mif.pg.gda.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200704171222.19892.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 April 2007 09:47:32 Tomasz Kłoczko wrote:
> On Tue, 17 Apr 2007, Theodore Tso wrote:
> [..]
>
> > Well, that was totally useless answer from the ZFS developers.  What
> > he should have told you is to contact Sun management, since they are
> > the only ones who can decide whether or not to release ZFS under a GPL
> > license, and more importantly, to give a patent license for any
> > patents they may have filed in the course of developing ZFS.  This is
> > not anything Linux developers can help you with.
>
> Realy can't or don't want (?)

As it has been explained to you before it is "can't"

> So who is responsible for potential changing Linux code licensing for
> allow if not incorporate CDDL code correct interraction without breaking
> some law ?

If I've parsed this query correctly the answer is: Linux is licensed under the 
GPL and because a number of people that have contributed code to it can no 
longer agree to a change in the license because they have died this cannot be 
changed. That was explained quite clearly in several mails as well.

> And/or what Linux can loose on follow this king changes ?
> And/or why Linux code licensing can't evolve ? Seems when Linux code was
> licensed noone was thinking about case like interraction with code under
> license like CDDL so why now it can be corrected and still many people try
> to think like "anything arond Linux must evolve .. but not Linux" (?)

When Linux was licensed under the GPL there was only *ONE* real choice for 
licensing it. Linus released the code under the GPL and there it has 
remained, with Linus leading development. If Linux had *NOT* been released 
under the GPL it would not be as popular or as powerful as it is - and that 
is not an opinion but a statement of fact.

> Why this can't be fixes ?

See the previous statement and several previous mails in this thread. Linux is 
licensed under the GPL, it is the *only* license agreed to by everyone that 
has contributed code. If I remember the statistics, there have been something 
like 10,000 different people that have contributed code. Since each 
contributor holds the copyright on their code they are the *ONLY* people that 
could change the license on it. Anyone attempting to change the license 
without agreement from *everyone* that has contributed code to the kernel 
they are in violation of US and international copyright laws.

> If in this ponit in Linux "evniroment" can't be chaged .. sorry but is it
> not kind of hipocritics ?

Nope. You've just ignored it when it was explained *why* the existing ZFS code 
cannot be simply be ported to Linux. If you really need ZFS on linux, might I 
suggest that you port the code on your own and maintain whatever patches are 
needed to use it? As it stands ZFS *might* show up in Linux as a from-scratch 
implementation, although I stress the "might" because there are patents 
involved.

DRH

(Now please, drop the subject - IMNSHO it is never going to happen)

