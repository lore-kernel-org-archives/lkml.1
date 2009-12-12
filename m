Return-Path: <linux-kernel-owner+w=401wt.eu-S1761471AbZLLKwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761471AbZLLKwz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 05:52:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754004AbZLLKwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 05:52:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41007 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788AbZLLKwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 05:52:53 -0500
Date: Sat, 12 Dec 2009 11:52:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <gregkh@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] TTY patches for 2.6.33-git
Message-ID: <20091212105237.GA4575@elte.hu>
References: <20091211232805.GA10652@kroah.com>
 <20091212084611.GA28266@elte.hu>
 <20091212013927.58d386d1.akpm@linux-foundation.org>
 <20091212100656.GA25286@elte.hu>
 <20091212101551.GA16049@elte.hu>
 <20091212024113.45ad2fed.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091212024113.45ad2fed.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sat, 12 Dec 2009 11:15:51 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > i'm testing the series of 5 reverts below. It's looking good so far. You 
> > might want to try them - how quickly can you reproduce the hangs?
> 
> Immediately, with http://userweb.kernel.org/~akpm/config-akpm2.txt

Ok. The lockups i saw went away with the 5 reverts i posted. I'll keep 
testing that over the weekend - that should narrow down the range very 
precisely.

	Ingo
