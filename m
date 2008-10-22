Return-Path: <linux-kernel-owner+w=401wt.eu-S1753705AbYJVHBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705AbYJVHBl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 03:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751557AbYJVHBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 03:01:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44685 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500AbYJVHBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 03:01:32 -0400
Date: Wed, 22 Oct 2008 09:01:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] trace: create tracers menu
Message-ID: <20081022070124.GE17485@elte.hu>
References: <1224599478.22771.45.camel@twins> <alpine.DEB.1.10.0810211040510.23141@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0810211040510.23141@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Tue, 21 Oct 2008, Peter Zijlstra wrote:
> 
> > Subject: trace: create tracers menu
> > From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Date: Tue Oct 21 16:26:36 CEST 2008
> > 
> > We seem to have plenty tracers, lets create a menu and not clutter
> > the already cluttered debug menu more.
> > 
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> Acked-by: Steven Rostedt <srostedt@redhat.com>

applied to tip/tracing/urgent, thanks!

	Ingo
