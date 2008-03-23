Return-Path: <linux-kernel-owner+w=401wt.eu-S935300AbYCWJNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935300AbYCWJNu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 05:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932671AbYCWJJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 05:09:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41691 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935032AbYCWJJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 05:09:53 -0400
Date: Sun, 23 Mar 2008 10:09:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joe Perches <joe@perches.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/148] include/asm-x86: checkpatch cleanups -
	formatting only
Message-ID: <20080323090933.GA25006@elte.hu>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Joe Perches <joe@perches.com> wrote:

> Cleanup to standardize formatting of .h files

thanks Joe, this is a good first step. I'll keep the 180 patches 
separated until it's in x86/testing, to ease bisection in the case of 
any (unlikely) problems - but after that we'll probably combine them 
into one single commit to not pollute the changelogs too much. In the 
future you might want to put them into a git tree and ask me to pull 
them, to not pollute lkml with 180 patches. (but, this is the least of 
our problems really)

	Ingo
