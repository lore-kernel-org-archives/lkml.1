Return-Path: <linux-kernel-owner+w=401wt.eu-S1754769AbZHYI2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbZHYI2O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 04:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753960AbZHYI2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 04:28:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46101 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754610AbZHYI2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 04:28:09 -0400
Date: Tue, 25 Aug 2009 10:27:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <JBeulich@novell.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86: Fix build with older binutils and
	consolidate linker script
Message-ID: <20090825082759.GB17692@elte.hu>
References: <4A8AEA1F0200007800010563@vpn.id2.novell.com> <tip-ddc98b38b6320d5de2e3167673a06ec1a48e9d0e@git.kernel.org> <20090825075029.GA857@elte.hu> <4A93B67D02000078000118B2@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A93B67D02000078000118B2@vpn.id2.novell.com>
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


* Jan Beulich <JBeulich@novell.com> wrote:

> Was that using a UP config perhaps?

yeah - UP 64-bit.

	Ingo
