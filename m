Return-Path: <linux-kernel-owner+w=401wt.eu-S1755650AbYHKQuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650AbYHKQuu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 12:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751754AbYHKQum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 12:50:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35673 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751604AbYHKQum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 12:50:42 -0400
Date: Mon, 11 Aug 2008 18:48:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, x86@kernel.org,
       akpm <akpm@linux-foundation.org>, jdmason@kudzu.us
Subject: Re: [PATCH] pci-calgary: fix function declaration
Message-ID: <20080811164852.GG4524@elte.hu>
References: <20080807151455.12b53aa5.randy.dunlap@oracle.com> <20080808070040.GA6931@il.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080808070040.GA6931@il.ibm.com>
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


* Muli Ben-Yehuda <muli@il.ibm.com> wrote:

> On Thu, Aug 07, 2008 at 03:14:55PM -0700, Randy Dunlap wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > cc: muli@il.ibm.com, jdmason@kudzu.us
> > 
> > Fix function declaration:
> > 
> > linux-next-20080807/arch/x86/kernel/pci-calgary_64.c:1353:36: warning: non-ANSI function declaration of function 'get_tce_space_from_tar'
> > 
> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>

applied to tip/x86/urgent - thanks.

	Ingo
