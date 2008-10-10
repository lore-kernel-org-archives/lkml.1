Return-Path: <linux-kernel-owner+w=401wt.eu-S1757203AbYJJJkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203AbYJJJkr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 05:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752818AbYJJJkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 05:40:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37552 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752668AbYJJJki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 05:40:38 -0400
Date: Fri, 10 Oct 2008 11:39:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <greg@kroah.com>, stable@kernel.org
Cc: Theodore Tso <tytso@mit.edu>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       David Smith <dsmith@redhat.com>, Roland McGrath <roland@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Wenji Huang <wenji.huang@oracle.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
Subject: Re: [PATCH] Marker depmod fix core kernel list
Message-ID: <20081010093942.GA15086@elte.hu>
References: <E1Klq8Z-0003Vd-L6@closure.thunk.org> <20081003195436.GA13506@Krystal> <20081004152456.GB23398@mit.edu> <20081006040820.GB26148@kroah.com> <20081010093901.GC13996@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081010093901.GC13996@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0180]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> the patch went upstream without a Cc: <stable@kernel.org> tag, so i'm 
> sending it here as a backport request. The upstream commit is below.

ah, ignore me - we broke it in .27-rc1 so .26 and earlier is not 
affected.

	Ingo
