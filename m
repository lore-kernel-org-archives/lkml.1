Return-Path: <linux-kernel-owner+w=401wt.eu-S1754132AbYHTKXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbYHTKXd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 06:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbYHTKXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 06:23:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50840 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbYHTKXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 06:23:24 -0400
Date: Wed, 20 Aug 2008 12:23:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Oruba <peter.oruba@amd.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Max Krasnyansky <maxk@qualcomm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [0/2 -tip] microcode: bug-fix + updates
Message-ID: <20080820102305.GH28492@elte.hu>
References: <1219183814.10426.28.camel@earth> <1219217486.10800.398.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219217486.10800.398.camel@twins>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Wed, 2008-08-20 at 00:10 +0200, Dmitry Adamushko wrote:
> > [ Peter Z., you may jump immediately to [*] :-) ]
> 
> Thanks - does the below help?

applied to tip/core/printk, under the assumption that it does the trick 
:-)

	Ingo
