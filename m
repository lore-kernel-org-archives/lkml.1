Return-Path: <linux-kernel-owner+w=401wt.eu-S934028AbZLFSwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934028AbZLFSwm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 13:52:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757010AbZLFSwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 13:52:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34645 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754310AbZLFSwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 13:52:41 -0500
Date: Sun, 6 Dec 2009 19:52:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       =?unknown-8bit?B?RnLDqWTDqXJpYw==?= Weisbecker 
	<fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT pull] bkl core patches for 2.6.33
Message-ID: <20091206185221.GA16319@elte.hu>
References: <alpine.LFD.2.00.0912061857340.3089@localhost.localdomain>
 <alpine.LFD.2.00.0912061044530.3560@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0912061044530.3560@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sun, 6 Dec 2009, Thomas Gleixner wrote:
> > 
> > Please pull the latest bkl-core-for-linus git tree from:
> 
> Hmm. Seeing this, I wonder: has anybody kept track of the reiserfs bkl 
> removal?

I've Cc:-ed Frederic - he's been hacking away on it diligently, for 
months meanwhile. Frederic, mind posting the URI to your tree?

	Ingo
