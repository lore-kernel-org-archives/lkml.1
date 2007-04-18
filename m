Return-Path: <linux-kernel-owner+w=401wt.eu-S1030990AbXDRCCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030990AbXDRCCg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 22:02:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030995AbXDRCCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 22:02:36 -0400
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:41816 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030990AbXDRCCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 22:02:35 -0400
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: AppArmor FAQ
Date: Wed, 18 Apr 2007 01:55:53 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <f03tr9$buk$1@taverner.cs.berkeley.edu>
References: <20070417181016.GA10903@one.firstfloor.org> <1176846088.5946.62.camel@localhost.localdomain> <f03fgh$2o1$1@taverner.cs.berkeley.edu> <Line.LNX.4.64.0704172036370.21359@d.namei>
Reply-To: daw-usenet@taverner.cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1176861353 12244 128.32.168.222 (18 Apr 2007 01:55:53 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Wed, 18 Apr 2007 01:55:53 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris  wrote:
>I would challenge the claim that AppArmor offers any magic bullet for
>ease of use.

There are, of course, no magic bullets for ease of use.
I would not make such a strong claim.  I simply stated that it
is plausible that AppArmor might have some advantages in some
deployment environments.

The purpose of LSM was to enable multiple different approaches to
security, so that we don't have to fight over the One True Way to
do it.  There might not be one best way for all situations.

These systems probably have different tradeoffs.  Consequently, it seems
to me that arguing over whether SELinux is superior to AppArmor makes
about as much sense as arguing over whether emacs is superior to vim,
or whether Python is superior to Perl.  The answer is likely to be
"it depends".

It's to be expected that SELinux developers prefer their own system
over AppArmor, or that AppArmor developers prefer AppArmor to SELinux.
(Have you ever seen any new parent who thinks their own baby is ugly?)
SELinux developers are likely to have built a system that addresses
the problems that seem important to them; other systems might set
priorities differently.

I think in this case the best remedy is to let many flowers bloom,
and let the users decide for themselves.
