Return-Path: <linux-kernel-owner+w=401wt.eu-S1760398AbYDUTdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760398AbYDUTdf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 15:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755958AbYDUTdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 15:33:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60828 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755959AbYDUTdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 15:33:25 -0400
Date: Mon, 21 Apr 2008 21:32:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: yhlu.kernel@gmail.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>, tglx@linutronix.de,
       aabdulla@nvidia.com, jeff@garzik.org
Subject: Re: [patch 3/4] x86_64: restore mask_bits in msi shutdown
Message-ID: <20080421193230.GB8770@elte.hu>
References: <200804182028.m3IKSKHY013602@imap1.linux-foundation.org> <86802c440804182315y5f7e4d80j678e7f510a8f0763@mail.gmail.com> <m163udu5by.fsf@frodo.ebiederm.org> <200804211221.22207.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804211221.22207.yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0240]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel.send@gmail.com> wrote:

> Andrew,
> 
> We should use this one.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
