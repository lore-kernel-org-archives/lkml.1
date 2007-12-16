Return-Path: <linux-kernel-owner+w=401wt.eu-S1762932AbXLPJGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762932AbXLPJGa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 04:06:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755616AbXLPJGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 04:06:05 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52932 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755554AbXLPJF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 04:05:59 -0500
Date: Sun, 16 Dec 2007 10:05:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rc5-git1: Reported regressions from 2.6.23
Message-ID: <20071216090540.GA28121@elte.hu>
References: <200712120243.27411.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712120243.27411.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> Subject		: 2.6.24-rc3-git2 softlockup detected
> Submitter	: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> Date		: 2007-11-28 15:46
> References	: http://lkml.org/lkml/2007/11/28/16
> 		  http://bugzilla.kernel.org/show_bug.cgi?id=9472
> Handled-By	: Andrew Morton <akpm@linux-foundation.org>
> 		  Ingo Molnar <mingo@elte.hu>
> Patch		: 

resolved by:

  http://lkml.org/lkml/2007/12/15/41

tested by Kamalesh Babulal:

  http://lkml.org/lkml/2007/12/15/97
  http://lkml.org/lkml/2007/12/16/1

	Ingo
