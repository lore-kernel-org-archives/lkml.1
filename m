Return-Path: <linux-kernel-owner+w=401wt.eu-S1759366AbYDKJp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759366AbYDKJp4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 05:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757449AbYDKJpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 05:45:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43869 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756803AbYDKJpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 05:45:46 -0400
Date: Fri, 11 Apr 2008 11:45:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [BUG] linux-next: Tree for April 9 warning on
	CC_STACKPROTECTOR, followed by kernel panic
Message-ID: <20080411094530.GI10801@elte.hu>
References: <20080409185309.b94c9d15.sfr@canb.auug.org.au> <47FDE045.4070509@linux.vnet.ibm.com> <20080410214711.cf0c57c7.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080410214711.cf0c57c7.sfr@canb.auug.org.au>
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


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> CC to Ingo ...

i've reverted the guilty patch and will push out a new x86.git soon.

	Ingo
