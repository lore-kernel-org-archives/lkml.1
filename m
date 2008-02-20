Return-Path: <linux-kernel-owner+w=401wt.eu-S1760525AbYBTI7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760525AbYBTI7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 03:59:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755044AbYBTI7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 03:59:05 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53821 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004AbYBTI7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 03:59:04 -0500
Date: Wed, 20 Feb 2008 09:58:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] x86: Coding style fixes to
	arch/x86/mach-generic/probe.c
Message-ID: <20080220085824.GA29899@elte.hu>
References: <20080219235717.0a4c69e2@paolo-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219235717.0a4c69e2@paolo-desktop>
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


* Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com> wrote:

> -	for (i = 0; apic_probe[i]; ++i) { 
> -		if (apic_probe[i]->mps_oem_check(mpc,oem,productid)) { 
> +	for (i = 0; apic_probe[i]; ++i) {
> +		if (apic_probe[i]->mps_oem_check(mpc, i oem, productid)) {

you typoed that one. Please build-test files you change.

	Ingo
