Return-Path: <linux-kernel-owner+w=401wt.eu-S1757842AbZFWNsC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842AbZFWNsC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 09:48:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757741AbZFWNry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 09:47:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55041 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755396AbZFWNrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 09:47:53 -0400
Date: Tue, 23 Jun 2009 15:47:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, paulus@samba.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [perf] howto switch from pfmon
Message-ID: <20090623134749.GA6897@elte.hu>
References: <4A3FEF75.2020804@inria.fr> <20090623131450.GA31519@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090623131450.GA31519@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

>  $ perf stat -e cycles -e instructions -e r1000ffe0 ./hackbench 10
>  Time: 0.186

Correction: that should be r10000ffe0.

	Ingo
