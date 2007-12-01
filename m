Return-Path: <linux-kernel-owner+w=401wt.eu-S1754604AbXLASeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbXLASeL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 13:34:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752955AbXLASdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 13:33:54 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52653 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753030AbXLASdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 13:33:54 -0500
Date: Sat, 1 Dec 2007 19:33:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [feature] automatically detect hung TASK_UNINTERRUPTIBLE tasks
Message-ID: <20071201183331.GB14052@elte.hu>
References: <20071201092037.GA32544@elte.hu> <alpine.DEB.0.9999.0712011031230.9694@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.9999.0712011031230.9694@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* David Rientjes <rientjes@google.com> wrote:

> The checked auto variable isn't doing anything in 
> check_hung_uninterruptible_tasks().

yeah, i used to print it out in a printk but removed it in the final 
version.

	Ingo
