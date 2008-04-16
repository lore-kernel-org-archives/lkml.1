Return-Path: <linux-kernel-owner+w=401wt.eu-S1757980AbYDPINM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980AbYDPINM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 04:13:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752531AbYDPIM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 04:12:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33838 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495AbYDPIMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 04:12:54 -0400
Date: Wed, 16 Apr 2008 10:12:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
       tglx@linuxtronix.de, hpa@zytor.com, akpm@linux-foundation.org
Subject: Re: [PATCH -next] x86: fix printk format
Message-ID: <20080416081235.GA2664@elte.hu>
References: <Pine.LNX.4.64.0804151514320.15946@shark.he.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804151514320.15946@shark.he.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0160]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Randy.Dunlap <rdunlap@xenotime.net> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix gcc printk format warnings:

thanks Randy, applied.

	Ingo
