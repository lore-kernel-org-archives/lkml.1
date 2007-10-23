Return-Path: <linux-kernel-owner+w=401wt.eu-S1752746AbXJWKeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbXJWKeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 06:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751491AbXJWKeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 06:34:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34001 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484AbXJWKeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 06:34:13 -0400
Date: Tue, 23 Oct 2007 12:33:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH 09/10] Change table chaining layout
Message-ID: <20071023103351.GA2795@elte.hu>
References: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com> <1193076664-13652-10-git-send-email-jens.axboe@oracle.com> <Pine.LNX.4.64.0710222137520.7105@anakin> <alpine.LFD.0.999.0710221248120.30120@woody.linux-foundation.org> <20071022211617.31f5c63d@the-village.bc.nu> <alpine.LFD.0.999.0710221343330.30120@woody.linux-foundation.org> <20071022224343.4abf3c96@the-village.bc.nu> <alpine.LFD.0.999.0710221444220.30120@woody.linux-foundation.org> <471DBEF4.4030303@panasas.com> <20071023094142.GD5059@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023094142.GD5059@kernel.dk>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jens Axboe <jens.axboe@oracle.com> wrote:

> It's all about the end goal - having maintainable and resilient code. 
> And I think the sg code will be better once we get past the next day 
> or so, and it'll be more robust. That is what matters to me, not the 
> simplicity of the patch itself.

Linus' latest tree, which has your SG-list enhancements included, 
certainly works fine here and does not have the problems of the first 
iteration.

	Ingo
