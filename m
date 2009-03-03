Return-Path: <linux-kernel-owner+w=401wt.eu-S1758063AbZCCID4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063AbZCCID4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 03:03:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbZCCIDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 03:03:47 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56911 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794AbZCCIDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 03:03:47 -0500
Date: Tue, 3 Mar 2009 09:03:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: Re: x86-tip: xine bustage bisection fingers commit
	97286a2b64725aac2d584ddd1f94871f9991d5a1
Message-ID: <20090303080333.GA11484@elte.hu>
References: <1235984665.6195.12.camel@marge.simson.net> <20090302093319.GB20897@elte.hu> <49AC85C1.7060600@ct.jp.nec.com> <1236060298.6060.1.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236060298.6060.1.camel@marge.simson.net>
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


* Mike Galbraith <efault@gmx.de> wrote:

> On Mon, 2009-03-02 at 17:20 -0800, Hiroshi Shimamoto wrote:
> 
> > I made a patch to fix this issue.
> > This patch is against tip/x86/signal.
> 
> Yes, this fixed my xine woes.

Applied, thanks guys!

	Ingo
