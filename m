Return-Path: <linux-kernel-owner+w=401wt.eu-S1765307AbXGYHxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765307AbXGYHxR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 03:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754870AbXGYHxC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 03:53:02 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55286 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966AbXGYHxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 03:53:00 -0400
Date: Wed, 25 Jul 2007 09:52:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: v2.6.22.1-rt5
Message-ID: <20070725075247.GB5125@elte.hu>
References: <20070724120436.GA14466@elte.hu> <200707241156.03149.gene.heskett@gmail.com> <20070724191027.GA13268@elte.hu> <200707242136.21457.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707242136.21457.gene.heskett@gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Gene Heskett <gene.heskett@gmail.com> wrote:

> Changing the "root (hd0,0)" to (sd0,0) failed.  Grub can't parse the 
> (sd0,0).

that (hd0,0) is a BIOS identification and needs no changing.

could you send me your grub.conf?

	Ingo
