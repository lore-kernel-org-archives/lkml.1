Return-Path: <linux-kernel-owner+w=401wt.eu-S1760663AbYA1PN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760663AbYA1PN2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 10:13:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753330AbYA1PNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 10:13:20 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54687 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754413AbYA1PNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 10:13:19 -0500
Date: Mon, 28 Jan 2008 16:13:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sudhir Kumar <skumar@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: 2.6.24-rc8-mm1 Kernel BUG while bootup
Message-ID: <20080128151300.GB12205@elte.hu>
References: <20080122135800.GA6084@in.ibm.com> <20080122155329.GA30119@elte.hu> <20080128145722.GB25517@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080128145722.GB25517@in.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Sudhir Kumar <skumar@linux.vnet.ibm.com> wrote:

> I applied all the hot fixes patches but still the bug is there. (crash 
> at early boot).
> 
> As I replied your earlier mail in which the patch sent by you does not 
> apply (reverse). can you please look into the problem ?

could you test latest x86.git:

   http://redhat.com/~mingo/x86.git/README

does that crash too?

	Ingo
