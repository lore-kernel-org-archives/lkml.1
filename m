Return-Path: <linux-kernel-owner+w=401wt.eu-S1756450AbYBQQeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450AbYBQQeQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 11:34:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752664AbYBQQeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 11:34:03 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35380 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403AbYBQQeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 11:34:01 -0500
Date: Sun, 17 Feb 2008 17:33:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Jeff Dike <jdike@addtoit.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] sched: add declaration of sched_tail to sched.h
Message-ID: <20080217163343.GI6006@elte.hu>
References: <1203098194.15275.3.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203098194.15275.3.camel@brick>
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


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> Avoids sparse warnings: kernel/sched.c:2170:17: warning: symbol 
> 'schedule_tail' was not declared. Should it be static?
> 
> Avoids the need for an external declaration in arch/um/process.c

thanks, applied.

	Ingo
