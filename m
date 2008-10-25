Return-Path: <linux-kernel-owner+w=401wt.eu-S1753252AbYJYHdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbYJYHdW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 03:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751653AbYJYHdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 03:33:10 -0400
Received: from mail.gmx.net ([213.165.64.20]:59471 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750761AbYJYHdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 03:33:09 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/8RTd7bqH8ScDlvUBKffpHZKuj08sfD+xxddQgV8
	5KgKqMCycNcbQQ
Subject: Re: [tbench regression fixes]: digging out smelly deadmen.
From: Mike Galbraith <efault@gmx.de>
To: David Miller <davem@davemloft.net>
Cc: rjw@sisk.pl, mingo@elte.hu, s0mbre@tservice.net.ru, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <20081025.001940.251852864.davem@davemloft.net>
References: <1224905848.5161.27.camel@marge.simson.net>
	 <20081024.221653.23695396.davem@davemloft.net>
	 <1224914333.3822.18.camel@marge.simson.net>
	 <20081025.001940.251852864.davem@davemloft.net>
Content-Type: text/plain
Date: Sat, 25 Oct 2008 09:33:05 +0200
Message-Id: <1224919985.5373.10.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.67
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-10-25 at 00:19 -0700, David Miller wrote:
> From: Mike Galbraith <efault@gmx.de>
> Date: Sat, 25 Oct 2008 07:58:53 +0200
> 
> > I spent long day manweeks trying to bisect and whatnot.  It's immune to
> > my feeble efforts, and my git-foo.
> 
> I understand, this is what happened to me when I tried to look into
> the gradual tbench regressions since 2.6.22

That's exactly what I've been trying to look into, but combined with
netperf.  The thing is an incredibly twisted maze of _this_ affects
_that_... sometimes involving magic and/or mythical creatures.

Very very annoying.

	-Mike

