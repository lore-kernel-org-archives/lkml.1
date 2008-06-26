Return-Path: <linux-kernel-owner+w=401wt.eu-S1757506AbYFZNSG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506AbYFZNSG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 09:18:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbYFZNRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 09:17:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57920 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823AbYFZNRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 09:17:51 -0400
Date: Thu, 26 Jun 2008 15:17:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@suse.cz>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@codemonkey.org.uk>, Andi Kleen <andi@firstfloor.org>,
       Trivial patch monkey <trivial@kernel.org>
Subject: Re: pci-gart_64.c: could we get better explanation?
Message-ID: <20080626131734.GA18444@elte.hu>
References: <20080526184703.GA17369@elf.ucw.cz> <1211831499.3286.2.camel@pasglop> <20080625222543.GD1844@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080625222543.GD1844@elf.ucw.cz>
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


* Pavel Machek <pavel@suse.cz> wrote:

> Add better explanation to pci-gart.

applied to tip/x86/gart - thanks Pavel.

	Ingo
