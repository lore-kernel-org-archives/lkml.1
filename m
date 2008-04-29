Return-Path: <linux-kernel-owner+w=401wt.eu-S1756944AbYD2JlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944AbYD2JlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 05:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752624AbYD2JlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 05:41:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50348 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440AbYD2JlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 05:41:07 -0400
Date: Tue, 29 Apr 2008 11:40:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <clameter@sgi.com>
Cc: travis@sgi.com, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch 0/9] [RFC] x86: Merge thread_info_32/64 to thread_info.h
Message-ID: <20080429094053.GA23198@elte.hu>
References: <20080429015231.908196699@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429015231.908196699@sgi.com>
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


* Christoph Lameter <clameter@sgi.com> wrote:

> The following patchset merges the 32 and 64 bit thread_info files into 
> one.
> 
> First just move the stuff into a single file and then gradually 
> extract common code. Ends up with pretty small differences. Had some 
> time last Saturday to play with it. Feedback/takeover appreciated.
> 
> Patch against git tree of today.

this unification looks very nicely structured. I'll throw it into the 
x86 testbed, lets see what happens.

	Ingo
