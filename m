Return-Path: <linux-kernel-owner+w=401wt.eu-S1754887AbYINOs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbYINOs5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 10:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbYINOsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 10:48:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57280 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042AbYINOst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 10:48:49 -0400
Date: Sun, 14 Sep 2008 16:44:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, Alexis Bruemmer <alexisb@us.ibm.com>
Subject: Re: [PATCH 1/2] x86: avoid unnecessary low zone allocation in
	Calgary's alloc_coherent
Message-ID: <20080914144432.GF12522@elte.hu>
References: <1221142128-28350-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1221142128-28350-2-git-send-email-fujita.tomonori@lab.ntt.co.jp> <20080911181006.GV6975@il.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080911181006.GV6975@il.ibm.com>
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


* Muli Ben-Yehuda <muli@il.ibm.com> wrote:

> Looks good,
> 
> Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>

applied to tip/x86/iommu, thanks.

	Ingo
