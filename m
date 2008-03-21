Return-Path: <linux-kernel-owner+w=401wt.eu-S1755561AbYCUJnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561AbYCUJnm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 05:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334AbYCUJnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 05:43:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53479 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753323AbYCUJnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 05:43:33 -0400
Date: Fri, 21 Mar 2008 10:43:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Zbigniew Luszpinski <zbiggy@o2.pl>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] arch/x86/kernel/quirks.c, kernel 2.6.24.3, hpet clock
	enable on nVidia nForce 430
Message-ID: <20080321094316.GH20420@elte.hu>
References: <200803191551.50538.zbiggy@o2.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803191551.50538.zbiggy@o2.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0021]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Zbigniew Luszpinski <zbiggy@o2.pl> wrote:

> this patch allows hpet=force on nVidia nForce 430 southbridge.
> This patch was tested by me on my old Asus A8N-VM CSM (where bios does not 
> support hpet and does not advertise it via acpi entry). [...]

thanks, applied.

	Ingo
