Return-Path: <linux-kernel-owner+w=401wt.eu-S1757249AbZCDR67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249AbZCDR67 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 12:58:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757035AbZCDR6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 12:58:39 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46094 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757014AbZCDR6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 12:58:38 -0500
Date: Wed, 4 Mar 2009 18:58:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Robert Richter <robert.richter@amd.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>, Tim Blechmann <tim@klingt.org>
Subject: Re: [Bug #12395] 2.6.28-rc9: oprofile regression
Message-ID: <20090304175828.GA1172@elte.hu>
References: <HFSEX4uppGO.A.JSG.2yzoJB@chimera> <LLno3yT_fnC.A.Lh.4zzoJB@chimera> <20090303113218.GE10085@erda.amd.com> <200903032055.23969.rjw@sisk.pl> <20090303204504.GA20038@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090303204504.GA20038@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > On Tuesday 03 March 2009, Robert Richter wrote:
> > > Fix upstream in tip/x86/urgent:
> > > 
> > > 780eef9492b16a1543a3b2ae9f9526a735fc9856
> > 
> > URL, please?
> 
> The fix is not yet in Linus's tree - the commit is below.

The fix is upstream now, included in .29-rc7.

	Ingo
