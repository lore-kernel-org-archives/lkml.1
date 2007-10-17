Return-Path: <linux-kernel-owner+w=401wt.eu-S932736AbXJQOJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932736AbXJQOJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 10:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754143AbXJQOJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 10:09:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54009 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753997AbXJQOJW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 10:09:22 -0400
Date: Wed, 17 Oct 2007 16:09:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix build breakage if !SYSFS
Message-ID: <20071017140911.GA4798@elte.hu>
References: <20071016130231.GA10778@linux-mips.org> <20071016174016.GC5693@linux.vnet.ibm.com> <20071016190044.GA24696@linux-mips.org> <20071017051611.GA11422@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017051611.GA11422@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:

> Could you please include this patch to fix the build breakage?

thanks - i've added this to the scheduler patch-queue.

	Ingo
