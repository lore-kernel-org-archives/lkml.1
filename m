Return-Path: <linux-kernel-owner+w=401wt.eu-S1755233AbXFLKkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbXFLKkt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 06:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbXFLKkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 06:40:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33404 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572AbXFLKkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 06:40:41 -0400
Date: Tue, 12 Jun 2007 12:40:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Con Kolivas <kernel@kolivas.org>
Cc: ck@vds.kolivas.org, Tobias Gerschner <tobias.gerschner@gmail.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: call for more SD versus CFS comparisons (was: Re: [ck]
	Mainline plans)
Message-ID: <20070612104032.GA8000@elte.hu>
References: <466DE921.9030709@debianpt.org> <20070612083620.GA10557@elte.hu> <20070612085730.GA17964@elte.hu> <200706122033.32883.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706122033.32883.kernel@kolivas.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Con Kolivas <kernel@kolivas.org> wrote:

> So unless there's a vm issue (which does not appear to be the case) I 
> can't see how any of these will change Tobias' extensive testing 
> results.

yep - i've retested with -ck2 and cannot reproduce his results. So i'm 
waiting for his feedback to see why this workload is behaving like that 
on his box and why not more like what other testers have found:

   http://bhhdoa.org.au/pipermail/ck/2007-June/007817.html

in any case, we'll figure this out :-)

	Ingo
