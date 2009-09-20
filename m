Return-Path: <linux-kernel-owner+w=401wt.eu-S1755607AbZITSyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607AbZITSyY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 14:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755594AbZITSyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 14:54:22 -0400
Received: from 1wt.eu ([62.212.114.60]:49153 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755591AbZITSyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 14:54:22 -0400
Date: Sun, 20 Sep 2009 20:54:23 +0200
From: Willy Tarreau <w@1wt.eu>
To: Grozdan <neutrino8@gmail.com>
Cc: linux-kernel@vger.kernel.org, shemminger@vyatta.com
Subject: Re: sky2 rx length errors
Message-ID: <20090920185423.GA30562@1wt.eu>
References: <c5bd819b0909180641n7c353b80tc15b9c9fe02d5c95@mail.gmail.com> <20090919233536.f5fb700c.akpm@linux-foundation.org> <20090920110527.39fd7af5@s6510> <c5bd819b0909201116u5a84c426tdd0f298d7019505d@mail.gmail.com> <20090920183458.GC28315@1wt.eu> <c5bd819b0909201146t35d921afh267c9430b114e23e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c5bd819b0909201146t35d921afh267c9430b114e23e@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 20, 2009 at 08:46:59PM +0200, Grozdan wrote:
(...)
> Thanks Willy :)
> 
> What I'm still wondering a bit though is the fact that I've never seen
> it behave like that for the past 3 years I've been using it. Only
> recently, with upgrading my kernel to 2.6.30 and later on to 2.6.31
> (self-compiled, sources taken from the openSUSE build service) it
> started to behave like that. In the past I also used older kernels (of
> course) like 2.6.27.x and 2.6.29 and never encountered this. So I'm a
> bit uncertain as to whether it's actually something in the kernel that
> makes it behave like that or that there's a HW problem that suddenly
> occurred or got exposed...

Unless you changed the switch port it is connected to, I agree this
sounds strange. I have also wondered if those issues could be caused
by temperature rising on the chip. I don't know if any recent change
could cause such environmental differences to occur :-/

Regards,
Willy

