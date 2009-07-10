Return-Path: <linux-kernel-owner+w=401wt.eu-S1756463AbZGJVS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463AbZGJVS2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 17:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752337AbZGJVSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 17:18:20 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:46576 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbZGJVST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 17:18:19 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/2] sched: INIT_PREEMPT_COUNT
Date: Fri, 10 Jul 2009 15:18:13 -0600
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Andrew Morton <akpm@linux-foundation.org>, oleg@redhat.com,
       mingo@elte.hu, tony.luck@intel.com, rth@twiddle.net,
       geert@linux-m68k.org
References: <20090710125755.559739294@chello.nl> <20090710130125.037018244@chello.nl>
In-Reply-To: <20090710130125.037018244@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200907101518.13894.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 July 2009 06:57:56 am Peter Zijlstra wrote:
> +#define INIT_PREEMPT_COUNT     (1)

If the parentheses are useful or necessary, I need to be
educated about why.  They look like superfluous paranoia to me.
