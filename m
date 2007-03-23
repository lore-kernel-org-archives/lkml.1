Return-Path: <linux-kernel-owner+w=401wt.eu-S1422759AbXCWKEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422759AbXCWKEf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 06:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422772AbXCWKEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 06:04:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51888 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422759AbXCWKEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 06:04:34 -0400
Date: Fri, 23 Mar 2007 11:04:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ravikiran G Thirumalai <kiran@scalex86.org>
Subject: Re: [rfc][patch] queued spinlocks (i386)
Message-ID: <20070323100418.GA30740@elte.hu>
References: <20070323085910.GA11577@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070323085910.GA11577@wotan.suse.de>
User-Agent: Mutt/1.4.2.2i
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


* Nick Piggin <npiggin@suse.de> wrote:

> Implement queued spinlocks for i386. [...]

isnt this patented by MS? (which might not worry you SuSE/Novell guys, 
but it might be a worry for the rest of the world ;-)

	Ingo
