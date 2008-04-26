Return-Path: <linux-kernel-owner+w=401wt.eu-S1758473AbYDZPoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758473AbYDZPoM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 11:44:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbYDZPn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 11:43:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55021 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752914AbYDZPnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 11:43:55 -0400
Date: Sat, 26 Apr 2008 17:43:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] VFS patches
Message-ID: <20080426154339.GA8268@elte.hu>
References: <20080426020221.GF5882@ZenIV.linux.org.uk> <20080426110139.GA23867@elte.hu> <20080426133512.GP14990@parisc-linux.org> <20080426134443.GA28860@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080426134443.GA28860@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > Did you have http://lkml.org/lkml/2008/4/26/1 applied?
> 
> not yet - will try that. (but i suspect it will fix it)

yep, that did the trick - thanks.

	Ingo
