Return-Path: <linux-kernel-owner+w=401wt.eu-S1752051AbXLKVHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051AbXLKVHk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 16:07:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750983AbXLKVHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 16:07:34 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50049 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbXLKVHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 16:07:33 -0500
Date: Tue, 11 Dec 2007 22:06:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>, Greg KH <gregkh@suse.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>, kay.sievers@vrfy.org
Subject: Re: 2.6.22.14 oops msg with commvault galaxy ?
Message-ID: <20071211210653.GA6902@elte.hu>
References: <F1D642E5A91BC94D9504EC83AE19E6B0015201B1@ecqcmtlmail3.quebec.int.ec.gc.ca> <20071210091501.deed38fa.randy.dunlap@oracle.com> <20071211145437.GA15617@linux.vnet.ibm.com> <20071211164319.GA14783@linux.vnet.ibm.com> <20071211170400.GA4861@suse.de> <20071211172338.GA17896@linux.vnet.ibm.com> <F1D642E5A91BC94D9504EC83AE19E6B0015201EF@ecqcmtlmail3.quebec.int.ec.gc.ca> <20071211182015.GA22339@linux.vnet.ibm.com> <20071211182528.GA5597@linux.vnet.ibm.com> <F1D642E5A91BC94D9504EC83AE19E6B0015201F1@ecqcmtlmail3.quebec.int.ec.gc.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F1D642E5A91BC94D9504EC83AE19E6B0015201F1@ecqcmtlmail3.quebec.int.ec.gc.ca>
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


* Fortier,Vincent [Montreal] <Vincent.Fortier1@EC.GC.CA> wrote:

> > That has changed from /sys/kernel/uids/<uid>/cpu_share
> > 
> 
> Here is my config.
> 
> Maybie I should give it a shot without CFS at all and see what 
> happends ?

and also with CFS but without CONFIG_FAIR_GROUP_SCHED.

	Ingo
