Return-Path: <linux-kernel-owner+w=401wt.eu-S1753578AbXLKV2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578AbXLKV2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 16:28:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751799AbXLKV2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 16:28:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38964 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807AbXLKV2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 16:28:11 -0500
Date: Tue, 11 Dec 2007 22:27:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [PATCH 4/4] x86: unify asm-x86/pgtable*.h
Message-ID: <20071211212755.GG6902@elte.hu>
References: <475DA7BF.8090606@goop.org> <20071211082910.GB15183@elte.hu> <475EC0A0.1000206@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475EC0A0.1000206@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Hm, odd.  I compiled and booted 32-bit and 64-bit.  Ah, though I may 
> have missed 32-bit non-PAE, which is your config.

the wonders of "make randconfig" testing :-)

	Ingo
