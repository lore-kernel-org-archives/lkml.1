Return-Path: <linux-kernel-owner+w=401wt.eu-S1756364AbYHUGNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364AbYHUGNf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 02:13:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752723AbYHUGN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 02:13:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58900 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550AbYHUGN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 02:13:26 -0400
Date: Thu, 21 Aug 2008 08:12:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ray Lee <ray-lk@madrabbit.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       adobriyan@gmail.com, "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, Chris Friesen <cfriesen@nortel.com>
Subject: Re: VolanoMark regression with 2.6.27-rc1
Message-ID: <20080821061258.GA14572@elte.hu>
References: <1912217169.25608.228.camel@ymzhang> <20080820143209.GA32156@x200.localdomain> <1219242796.8651.54.camel@twins> <200808210110.37204.nickpiggin@yahoo.com.au> <2c0942db0808200929r640b3a1cj33efc56cfd6db9b3@mail.gmail.com> <1219252901.8651.63.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219252901.8651.63.camel@twins>
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

> Ok, so one last time (I hope!)..
> 
> Everybody happy with this?

looks good to me. What is missing is Yanmin's confirmation that the 
patch indeed solves/improves the regression :-)

	Ingo
