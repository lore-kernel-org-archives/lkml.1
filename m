Return-Path: <linux-kernel-owner+w=401wt.eu-S1759198AbXI1Pkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759198AbXI1Pkj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 11:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753607AbXI1Pka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 11:40:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42040 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765AbXI1Pk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 11:40:29 -0400
Date: Fri, 28 Sep 2007 17:40:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@qumranet.com>
Subject: Re: Add missing profile=kvm option to
	Documentation/kernel-parameters.txt
Message-ID: <20070928154012.GA18631@elte.hu>
References: <20070928153220.GA26969@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070928153220.GA26969@redhat.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0019]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Jones <davej@redhat.com> wrote:

> Whilst looking up what profile=sleep did, I noticed that we missed 
> adding docs for the most recent addition to the profiler.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
