Return-Path: <linux-kernel-owner+w=401wt.eu-S1762705AbYD2U4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762705AbYD2U4X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 16:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758026AbYD2U4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 16:56:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44100 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758002AbYD2U4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 16:56:03 -0400
Date: Tue, 29 Apr 2008 22:55:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [bug - scsi/blk] -git, WARNING: at include/linux/blkdev.h:427
	__blk_run_queue+0x74/0xa0()
Message-ID: <20080429205531.GB22298@elte.hu>
References: <20080429195508.GA30109@elte.hu> <20080429200419.GF12774@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429200419.GF12774@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0003]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jens Axboe <jens.axboe@oracle.com> wrote:

> >  http://redhat.com/~mingo/misc/log-Tue_Apr_29_21_40_46_CEST_2008.bad
> >  http://redhat.com/~mingo/misc/config-Tue_Apr_29_21_40_46_CEST_2008.bad
> 
> 404 on those, but I think Bart and I already closed this one:

thx, i'll yell if it still occurs with latest -git.

	Ingo
