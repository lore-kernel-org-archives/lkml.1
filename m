Return-Path: <linux-kernel-owner+w=401wt.eu-S1755900AbYCUOY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900AbYCUOY5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 10:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753533AbYCUOYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 10:24:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51141 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753378AbYCUOYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 10:24:47 -0400
Date: Fri, 21 Mar 2008 15:24:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jack Steiner <steiner@sgi.com>
Cc: ak@suse.de, tglx@linutronix.de, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] - Increase max physical memory size of x86_64
Message-ID: <20080321142433.GA31719@elte.hu>
References: <20080321133157.GA10911@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080321133157.GA10911@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1054]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jack Steiner <steiner@sgi.com> wrote:

> Increase the maximum physical address size of x86_64 system to 
> 44-bits. This is in preparation for future chips that support larger 
> physical memory sizes.

thanks, applied.

	Ingo
