Return-Path: <linux-kernel-owner+w=401wt.eu-S1754863AbXFIPGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbXFIPGn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 11:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752874AbXFIPGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 11:06:33 -0400
Received: from pat.uio.no ([129.240.10.15]:57162 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752884AbXFIPGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 11:06:32 -0400
Subject: Re: networking busted in current -git ???
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: David Miller <davem@davemloft.net>
Cc: arekm@maven.pl, florin@iucha.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <20070608.190608.117446027.davem@davemloft.net>
References: <20070608205640.GI30661@iucha.net>
	 <200706082307.45722.arekm@maven.pl>
	 <1181339007.6675.12.camel@heimdal.trondhjem.org>
	 <20070608.190608.117446027.davem@davemloft.net>
Content-Type: text/plain
Date: Sat, 09 Jun 2007 11:06:10 -0400
Message-Id: <1181401570.6240.0.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.104)
X-UiO-Scanned: 634E1F5ED65B758C349D383D9E1BAED336E17122
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 29 total 2274754 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-08 at 19:06 -0700, David Miller wrote:
> From: Trond Myklebust <trond.myklebust@fys.uio.no>
> Date: Fri, 08 Jun 2007 17:43:27 -0400
> 
> > It is not dhcp. I'm seeing the same bug with bog-standard ifup with a
> > static address on an FC-6 machine.
> > 
> > It appears to be something in the latest dump from davem to Linus, but I
> > haven't yet had time to identify what.
> 
> Linus's current tree should have this fixed.
> 
> Let us know if this is not the case.

It appears to be working for me again.

Trond

