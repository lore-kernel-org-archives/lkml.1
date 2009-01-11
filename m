Return-Path: <linux-kernel-owner+w=401wt.eu-S1755960AbZAKCuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960AbZAKCuF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 21:50:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbZAKCty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 21:49:54 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44727 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567AbZAKCty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 21:49:54 -0500
Date: Sun, 11 Jan 2009 03:49:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Laurent Riffard <laurent.riffard@free.fr>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: next-20090107: WARNING: at kernel/sched.c:4435
	sub_preempt_count
Message-ID: <20090111024945.GC7077@elte.hu>
References: <4966897E.5020302@free.fr> <f19298770901090209m7076f3afyd1e01e0fc9bbca59@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f19298770901090209m7076f3afyd1e01e0fc9bbca59@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexey Zaytsev <alexey.zaytsev@gmail.com> wrote:

> One more instance of http://marc.info/?l=linux-kernel&m=123134586202636&w=2
> Added Ingo Molnar to CC.

added Nick on Cc:. Nick, it's about:

> commit 7317d7b87edb41a9135e30be1ec3f7ef817c53dd
> Author: Nick Piggin <nickpiggin@yahoo.com.au>
> Date:   Tue Sep 30 20:50:27 2008 +1000
>
>    sched: improve preempt debugging

causing a seemingly spurious warning.

	Ingo
