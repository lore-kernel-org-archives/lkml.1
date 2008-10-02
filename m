Return-Path: <linux-kernel-owner+w=401wt.eu-S1754322AbYJBIpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322AbYJBIpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 04:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbYJBIpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 04:45:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47184 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582AbYJBIph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 04:45:37 -0400
Date: Thu, 2 Oct 2008 10:45:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Ulrich Drepper <drepper@redhat.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Michael Kerrisk <mtk.manpages@googlemail.com>
Subject: Re: [RFC patch 0/3] signals: add rt_tgsigqueueinfo syscall V2
Message-ID: <20081002084524.GE26084@elte.hu>
References: <20081001095204.343984413@linutronix.de> <20081001173933.54D0015427F@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081001173933.54D0015427F@magilla.localdomain>
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


* Roland McGrath <roland@redhat.com> wrote:

> Not that I tested it or anything, but this gets a theoretical ACK from me.

btw., you can send a Reviewed-by: Roland McGrath <roland@redhat.com> 
line in that case - i'm sure Thomas will appreciate it.

	Ingo
