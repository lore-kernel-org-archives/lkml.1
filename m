Return-Path: <linux-kernel-owner+w=401wt.eu-S1757192AbZHZHbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192AbZHZHbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 03:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757156AbZHZHby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 03:31:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40352 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757101AbZHZHbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 03:31:53 -0400
Date: Wed, 26 Aug 2009 09:31:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH] pci/intr_remapping: allocate irq_iommu on node -v3
Message-ID: <20090826073101.GD23435@elte.hu>
References: <4A84C13E.5050606@kernel.org> <4A84C190.1060005@kernel.org> <4A84C21A.4000705@kernel.org> <20090825114859.777be874@jbarnes-g45>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090825114859.777be874@jbarnes-g45>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> Ingo, I assume you took these two?

not yet - was waiting on noises from you and David. So the series 
looks good to you from a PCI perspective and i can add your 
acked-by? Would go into the IRQ tree.

	Ingo
