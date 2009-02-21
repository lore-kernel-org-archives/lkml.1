Return-Path: <linux-kernel-owner+w=401wt.eu-S1754213AbZBUIjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbZBUIjf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 03:39:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752640AbZBUIj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 03:39:27 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37473 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615AbZBUIj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 03:39:27 -0500
Date: Sat, 21 Feb 2009 09:39:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 fixes
Message-ID: <20090221083910.GA12006@elte.hu>
References: <20090219171005.GA27922@elte.hu> <alpine.LFD.2.00.0902201809260.21686@localhost.localdomain> <20090221083212.GA1537@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090221083212.GA1537@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> | commit fa2144ba9a31d1d0dc9607508576c3850e0d95b1
> | Author: Sam Ravnborg <sam@ravnborg.org>
> | Date:   Fri Feb 15 13:53:11 2008 +0100
> |
> |     kbuild: explain why DEBUG_SECTION_MISMATCH is UNDEFINED

hm, that's 2008 not 2009.

I dont know why the section warnings went away, but i frequently 
saw these warnings and i never forced 
CONFIG_DEBUG_SECTION_MISMATCH on the command line.

	Ingo
