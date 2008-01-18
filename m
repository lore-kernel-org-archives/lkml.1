Return-Path: <linux-kernel-owner+w=401wt.eu-S1763350AbYARQtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763350AbYARQtU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 11:49:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761631AbYARQtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 11:49:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37150 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757800AbYARQtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 11:49:12 -0500
Date: Fri, 18 Jan 2008 17:48:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, jbeulich@novell.com,
       venkatesh.pallipadi@intel.com
Subject: Re: CPA boot crash (was: [PATCH] [0/36] Great change_page_attr
	patch series v3)
Message-ID: <20080118164853.GA17589@elte.hu>
References: <200801161114.239449000@suse.de> <200801181716.06093.ak@suse.de> <20080118162118.GA6819@elte.hu> <200801181734.51193.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801181734.51193.ak@suse.de>
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


* Andi Kleen <ak@suse.de> wrote:

> That rule of thumb makes sense if someone does a series from scratch, 
> but redoing a large existing series just because someone else sneaked 
> in a white space patch at the wrong time does not seem to be very 
> efficient to me.

i pointed it out how to port a larger series ontop of a whitespace 
cleanup patch:

 http://lkml.org/lkml/2008/1/18/281

the "there's an easy technique" bit. Repeat that method for every patch 
and you'll have your series ported ontop the whitespace cleanups. (with 
no risks)

	Ingo
