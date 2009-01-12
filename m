Return-Path: <linux-kernel-owner+w=401wt.eu-S1758290AbZALWWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290AbZALWWA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 17:22:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbZALWVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 17:21:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35481 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853AbZALWVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 17:21:50 -0500
Date: Mon, 12 Jan 2009 23:21:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] irq: update all archs to use new irq_desc
	cpumask_var_t's.
Message-ID: <20090112222123.GB15294@elte.hu>
References: <20090112220519.566749000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090112220519.566749000@polaris-admin.engr.sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> Ingo - should I push these to tip/cpus4096 via the cpus4096-for-ingo 
> tree since that has the relevant changes to irq_desc?  Or by some other 
> means?

yes, please update cpus4096-for-ingo so that i can pull it from your tree.

	Ingo
