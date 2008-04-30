Return-Path: <linux-kernel-owner+w=401wt.eu-S1763278AbYD3MK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763278AbYD3MK2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 08:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759925AbYD3MJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 08:09:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52504 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759503AbYD3MJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 08:09:47 -0400
Date: Wed, 30 Apr 2008 14:09:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: yhlu.kernel@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Gabriel C <nix.or.die@googlemail.com>,
       Mika Fischer <mika.fischer@zoopnet.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix trimming e820 with MTRR holes. - fix
Message-ID: <20080430120924.GA30735@elte.hu>
References: <200804272337.40130.yhlu.kernel@gmail.com> <200804290157.30651.yhlu.kernel@gmail.com> <200804290159.49882.yhlu.kernel@gmail.com> <200804292025.17159.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804292025.17159.yhlu.kernel@gmail.com>
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


* Yinghai Lu <yhlu.kernel.send@gmail.com> wrote:

> v2: process hole then end_pfn
>     fix update_memory_range with whole cover comparing

thanks, applied.

	Ingo
