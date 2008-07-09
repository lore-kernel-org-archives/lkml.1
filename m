Return-Path: <linux-kernel-owner+w=401wt.eu-S1756051AbYGIFwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbYGIFwX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 01:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751269AbYGIFwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 01:52:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60545 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156AbYGIFwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 01:52:09 -0400
Date: Wed, 9 Jul 2008 07:51:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jack Steiner <steiner@sgi.com>
Cc: tglx@linutronix.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] - Map UV chipset space - pagetable
Message-ID: <20080709055155.GC9760@elte.hu>
References: <20080701194532.GA28405@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701194532.GA28405@sgi.com>
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


* Jack Steiner <steiner@sgi.com> wrote:

> Add boot-time function for creating additional 2MB page table entries 
> for mapping chipset specific cached/uncached ranges.

applied to tip/x86/core, thanks Jack.

	Ingo
