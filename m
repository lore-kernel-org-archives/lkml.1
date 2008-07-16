Return-Path: <linux-kernel-owner+w=401wt.eu-S1759117AbYGPOys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759117AbYGPOys (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 10:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752452AbYGPOyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 10:54:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56217 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756784AbYGPOyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 10:54:36 -0400
Date: Wed, 16 Jul 2008 16:54:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [build fix] Re: [GIT PATCH] SCSI part 1
Message-ID: <20080716145423.GA18288@elte.hu>
References: <1216138543.3312.60.camel@localhost.localdomain> <20080716101634.GA8494@elte.hu> <20080716103337.GA22931@elte.hu> <20080716131543.GA3673@elte.hu> <1216216320.3230.1.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216216320.3230.1.camel@localhost.localdomain>
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


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix fs/compat_ioctl.c to handle CONFIG_BLOCK=n, CONFIG_SCSI=n
> to avoid build errors:

btw., this patch too solves my build problems.

  Tested-by: Ingo Molnar <mingo@elte.hu>

Thanks,

	Ingo
