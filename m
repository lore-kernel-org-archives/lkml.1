Return-Path: <linux-kernel-owner+w=401wt.eu-S1761240AbYA1OF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761240AbYA1OF3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 09:05:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757478AbYA1OFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 09:05:20 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49695 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756412AbYA1OFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 09:05:18 -0500
Date: Mon, 28 Jan 2008 15:04:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, tglx@tglx.de, hpa@zytor.com
Subject: Re: [patch 3/3] x86: deprecate change_page_attr() for drivers
Message-ID: <20080128140458.GC27928@elte.hu>
References: <20080125145212.5ad8fbec@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080125145212.5ad8fbec@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0073]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@infradead.org> wrote:

> Subject: x86: deprecate change_page_attr()
> From: Arjan van de Ven <arjan@linux.intel.com>
> 
> With the introduction of the new API, no driver or non-archcore code 
> needs to use c-p-a anymore, so this patch also deprecates the 
> EXPORT_SYMBOL of CPA (it's a horrible API after all).

agreed. Nice changes :)

	Ingo
