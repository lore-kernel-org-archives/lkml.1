Return-Path: <linux-kernel-owner+w=401wt.eu-S1754678AbYKLSzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbYKLSzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 13:55:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbYKLSyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 13:54:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57815 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671AbYKLSyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 13:54:50 -0500
Date: Wed, 12 Nov 2008 19:54:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mark.langsdorf@amd.com
Subject: Re: [PATCH] Warn of incorrect cpu_khz on AMD systems
Message-ID: <20081112185423.GA15463@elte.hu>
References: <20081104152720.9964.71959.sendpatchset@prarit.bos.redhat.com> <20081106090118.GC4890@elte.hu> <491B21D4.5030001@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491B21D4.5030001@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0574]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Prarit Bhargava <prarit@redhat.com> wrote:

> New patch replacing printk with WARN() based on Ingo's suggestion...

applied to tip/x86/debug, thanks Prarit!

	Ingo
