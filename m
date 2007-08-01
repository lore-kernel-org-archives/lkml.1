Return-Path: <linux-kernel-owner+w=401wt.eu-S1763475AbXHAIQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763475AbXHAIQn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 04:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760712AbXHAIQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 04:16:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60575 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760615AbXHAIQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 04:16:26 -0400
Date: Wed, 1 Aug 2007 10:16:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net, gregkh@suse.de,
       linuxppc-dev@ozlabs.org, paulus@samba.org
Subject: Re: 2.6.23-rc1-mm2
Message-ID: <20070801081600.GA30482@elte.hu>
References: <20070731230932.a9459617.akpm@linux-foundation.org> <200708011002.30962.m.kozlowski@tuxland.pl> <20070801011323.6e8d8259.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070801011323.6e8d8259.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 1 Aug 2007 10:02:30 +0200 Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:
> 
> > Hello,
> > 
> > 	I get this warning. Looking at the comment in kernel/irq/resend.c
> > it's harmless. Is it?

yeah, harmless.

	Ingo
