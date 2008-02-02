Return-Path: <linux-kernel-owner+w=401wt.eu-S932162AbYBBKWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162AbYBBKWU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 05:22:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761187AbYBBKWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 05:22:07 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44899 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760950AbYBBKWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 05:22:05 -0500
Date: Sat, 2 Feb 2008 11:21:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 6 of 7] x86: move pud/pgd functions into common
	asm/pgalloc.h
Message-ID: <20080202102145.GA22233@elte.hu>
References: <patchbomb.1201943112@localhost> <fe3ff49757e16a5b9290.1201943118@localhost> <20080202101356.GA19782@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080202101356.GA19782@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> random-qa found an early bootup hang on 32-bit (config attached).

s/32-bit/64-bit

	Ingo
