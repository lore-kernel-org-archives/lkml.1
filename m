Return-Path: <linux-kernel-owner+w=401wt.eu-S1755869AbYGJG0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869AbYGJG0i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 02:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbYGJG0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 02:26:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37016 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835AbYGJG03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 02:26:29 -0400
Date: Thu, 10 Jul 2008 08:26:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, joerg.roedel@amd.com,
       tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       Sebastian.Biemueller@amd.com, robert.richter@amd.com, joro@8bytes.org
Subject: Re: [PATCH 16/34] AMD IOMMU: add kernel command line parameters
	for AMD IOMMU
Message-ID: <20080710062603.GB23054@elte.hu>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com> <1214508490-29683-17-git-send-email-joerg.roedel@amd.com> <20080709185634.08c60937.akpm@linux-foundation.org> <20080710132447T.fujita.tomonori@lab.ntt.co.jp> <20080709213907.1e8b253b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080709213907.1e8b253b.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 10 Jul 2008 13:25:23 +0900 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > I have one related question, we should document all the kernel boot
> > parameters in Documentation/kernel-parameters.txt?
> > 
> > Some of x86_64 boot parameters are in
> > Documentations/x86/x86_64/boot-options.txt. The parameters of IOMMUs
> > are scattered. It's confusing.
> 
> A single monolithic file has advantages.  I think I'd prefer that 
> personally.  I'd forgotten that the x86-specific one exists, actually.

yeah, it should be all in Documentation/kernel-parameters.txt.

	Ingo
