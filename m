Return-Path: <linux-kernel-owner+w=401wt.eu-S1753159AbYK1KeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159AbYK1KeX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 05:34:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750912AbYK1KeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 05:34:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59079 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739AbYK1KeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 05:34:12 -0500
Date: Fri, 28 Nov 2008 11:34:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?B?VPZy9ms=?= Edwin <edwintorok@gmail.com>
Cc: adobriyan@gmail.com, sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix build: add missing #ifdef CONFIG_STACKTRACE
Message-ID: <20081128103400.GA11341@elte.hu>
References: <c62985530811280114s50abe288q255a185b6d64c81b@mail.gmail.com> <1227863876-22747-1-git-send-email-edwintorok@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1227863876-22747-1-git-send-email-edwintorok@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Török Edwin <edwintorok@gmail.com> wrote:

> 
> Signed-off-by: Török Edwin <edwintorok@gmail.com>
> ---
>  kernel/trace/trace.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)

applied to tip/tracing/stack-tracer, and pushed out into ftrace-next, thanks 
Edwin!

	Ingo
