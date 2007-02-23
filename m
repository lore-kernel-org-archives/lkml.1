Return-Path: <linux-kernel-owner+w=401wt.eu-S932213AbXBWLlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213AbXBWLlO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 06:41:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932206AbXBWLlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 06:41:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56228 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932145AbXBWLlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 06:41:12 -0500
Date: Fri, 23 Feb 2007 12:36:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: circular locking: /proc/sys/vm/drop_caches
Message-ID: <20070223113615.GC1177@elte.hu>
References: <20070223063538.GA13679@elte.hu> <20070223020743.28ede2d4.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070223020743.28ede2d4.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.1.7
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4920]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> The only (lame) thing I can say for now is that drop_caches is a 
> debug-only, root-only thing :(

ok, that's fair enough.

	Ingo
