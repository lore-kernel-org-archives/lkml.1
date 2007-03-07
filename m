Return-Path: <linux-kernel-owner+w=401wt.eu-S1422954AbXCGRxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422954AbXCGRxr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:53:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422773AbXCGRx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:53:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42511 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422790AbXCGRxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:53:20 -0500
Date: Wed, 7 Mar 2007 18:52:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: tglx@linutronix.de, Dan Hecht <dhecht@vmware.com>,
       Zachary Amsden <zach@vmware.com>, akpm@linux-foundation.org, ak@suse.de,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>, john stultz <johnstul@us.ibm.com>
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
Message-ID: <20070307175232.GB31371@elte.hu>
References: <45EDD82F.90204@vmware.com> <1173225182.24738.507.camel@localhost.localdomain> <45EE0628.1080108@goop.org> <45EE08E8.2020008@vmware.com> <1173228544.24738.514.camel@localhost.localdomain> <45EE0D10.7070807@vmware.com> <1173230305.24738.529.camel@localhost.localdomain> <45EE1EA3.90803@vmware.com> <1173256666.24738.576.camel@localhost.localdomain> <45EEF966.6060902@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45EEF966.6060902@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> I don't think having a clock implementation for each hypervisor is 
> such a big deal.  The Xen one, for example, is 300 lines of 
> straightforward code.

/For you/ it's certainly no big deal, you dont have to fix it up and you 
dont have to keep it flexible ;)

and really, i'm not expecting miracles, i've never seen any hardware 
vendor argue /against/ support for their own hardware =B-)

	Ingo
