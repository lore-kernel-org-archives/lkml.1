Return-Path: <linux-kernel-owner+w=401wt.eu-S1755093AbXH0Jll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093AbXH0Jll (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 05:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752737AbXH0Jle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 05:41:34 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:54867 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540AbXH0Jld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 05:41:33 -0400
Message-ID: <46D29C3D.5070801@garzik.org>
Date: Mon, 27 Aug 2007 05:41:17 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Daniel Walker <dwalker@mvista.com>,
       =?ISO-8859-1?Q?Bj=F6rn_Steinbrink?= <B.Steinbrink@gmx.de>,
       eranian@hpl.hp.com, ak@suse.de, linux-kernel@vger.kernel.org,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: Who wants to maintain KR list for stable releases? (was Re: nmi_watchdog=2
 regression in 2.6.21)
References: <1186531609.22044.50.camel@imap.mvista.com>	<20070808142059.GF30805@atjola.homenet>	<1187628296.7732.14.camel@imap.mvista.com>	<46CDE94A.7000600@googlemail.com>	<1187904169.2435.83.camel@dhcp193.mvista.com>	<46D21E8E.4000003@googlemail.com> <20070827005131.b93f5935.akpm@linux-foundation.org>
In-Reply-To: <20070827005131.b93f5935.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> What I'm concerned about is that regressions which we didn't fix are just
> getting lost.  Is anyone taking care to ensure that they are getting
> transitioned into bugzilla for tracking?

Maybe this was a dumb assumption on my part, but I thought regressions 
were getting rolled over into the next release's list, if they are not 
solved?

	Jeff


