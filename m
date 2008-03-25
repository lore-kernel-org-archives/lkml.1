Return-Path: <linux-kernel-owner+w=401wt.eu-S1758021AbYCYPtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021AbYCYPtn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 11:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757935AbYCYPtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 11:49:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33124 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757916AbYCYPtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 11:49:31 -0400
Date: Tue, 25 Mar 2008 16:49:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/1] Arch-x86: pgtable, document pde bits
Message-ID: <20080325154915.GB27174@elte.hu>
References: <1206208222-9671-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206208222-9671-1-git-send-email-jirislaby@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2439]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Slaby <jirislaby@gmail.com> wrote:

> Some of pde bits weren't documented, add the short description to them.

thanks Jiri, applied. 

	Ingo
