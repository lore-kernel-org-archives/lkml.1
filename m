Return-Path: <linux-kernel-owner+w=401wt.eu-S1759859AbXLRPpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759859AbXLRPpP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 10:45:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756656AbXLRPo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 10:44:59 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55558 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756158AbXLRPo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 10:44:58 -0500
Date: Tue, 18 Dec 2007 16:44:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de, ehabkost@redhat.com, jeremy@goop.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       ak@suse.de, chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com,
       zach@vmware.com, roland@redhat.com
Subject: Re: [PATCH 21/21] [PATCH] finish processor.h integration
Message-ID: <20071218154415.GA12238@elte.hu>
References: <11979320451308-git-send-email-gcosta@redhat.com> <1197932050948-git-send-email-gcosta@redhat.com> <11979320551036-git-send-email-gcosta@redhat.com> <11979320603229-git-send-email!-gcosta@redhat.com> <11979320653161-git-send-email-gcosta@redhat.com> <11979320693300-git-send-email-gcosta@redhat.com> <20071218131932.GA9457@elte.hu> <20071218133818.GA9941@elte.hu> <20071218134018.GA13193@elte.hu> <4767D005.6040909@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4767D005.6040909@redhat.com>
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


* Glauber de Oliveira Costa <gcosta@redhat.com> wrote:

> Ingo Molnar wrote:
>> * Ingo Molnar <mingo@elte.hu> wrote:
>>
>>> yes, our include file dependencies are a jungle, the differences between 
>>> 32-bit and 64-bit are arbitrary in 80% of the cases, but still there's no 
>>> reason why this couldnt be done correctly. The patch below is a quick 
>>> bandaid that adds the missing bits.
>>
>> the bandaid didnt work - so i removed the 21/21 patch for the time being.
>
> I will also have updates for other patches, If you want, you can drop 
> the series entirely, and wait for the new one to come

please send delta patches for this lot from now on - those are a lot 
more testable.

	Ingo
