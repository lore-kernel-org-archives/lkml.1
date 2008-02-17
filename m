Return-Path: <linux-kernel-owner+w=401wt.eu-S1756757AbYBQQmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757AbYBQQmu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 11:42:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753201AbYBQQmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 11:42:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50684 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823AbYBQQml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 11:42:41 -0500
Date: Sun, 17 Feb 2008 17:42:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Robert Hancock <hancockr@shaw.ca>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] x86: validate against acpi motherboard resources
Message-ID: <20080217164224.GK6006@elte.hu>
References: <fa.LKjQjbOw482S/QFVaQ9fSrM+IFw@ifi.uio.no> <fa.wuwhrqFp6CufvpAJxShHqIaOPdI@ifi.uio.no> <47B67A0E.7060605@shaw.ca> <86802c440802152209p34965e70o8f20e957a6487423@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440802152209p34965e70o8f20e957a6487423@mail.gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> linus already apply the the patch to "use MMCONFIG for extended config 
> space only" to mainline. the last two near 2.6.25-rc1.
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=a0ca9909609470ad779b9b9cc68ce96e975afff7
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=b6ce068a1285a24185b01be8a49021827516b3e1

FYI, we've applied your patches to x86.git, they certainly look 
sensible.

	Ingo
