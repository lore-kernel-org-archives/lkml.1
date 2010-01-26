Return-Path: <linux-kernel-owner+w=401wt.eu-S1753052Ab0AZHan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052Ab0AZHan (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 02:30:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752412Ab0AZHak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 02:30:40 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:12745 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab0AZHaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 02:30:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZER9asFqnyjYFlb2L2lhkz1CPc4XlinylA8A7GQeDltOmvmdc2bDsY2r+sTC3wN4Mq
         eUnti20WAzkHyuip73vOMgLPPhqyMRM/9YMHhdyNOzzWDEslEOFhx+C0qnN7o3c86FtR
         R8IPrT5Ff7+728bbffugwTbw7xQ0Ih9dPXos4=
Date: Tue, 26 Jan 2010 07:30:33 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
Message-ID: <20100126073033.GA6972@ff.dom.local>
References: <20100125.165634.92235663.davem@davemloft.net> <20100126063326.GA6360@ff.dom.local> <20100125.231735.216761126.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100125.231735.216761126.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 25, 2010 at 11:17:35PM -0800, David Miller wrote:
> From: Jarek Poplawski <jarkao2@gmail.com>
> Date: Tue, 26 Jan 2010 06:33:26 +0000
> 
> > On 26-01-2010 01:56, David Miller wrote:
> >> are available in the git repository at:
> >> 
> >>   master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git master
> > 
> > David, I hope I miss something, but there seem to be older things too:
> > ...
> >> Jarek Poplawski (1):
> >>       ax25: netrom: rose: Fix timer oopses
> 
> That was commited on January 16th.
> 
> commit d00c362f1b0ff54161e0a42b4554ac621a9ef92d
> Author: Jarek Poplawski <jarkao2@gmail.com>
> Date:   Sat Jan 16 01:04:04 2010 -0800
...
> And I haven't sent a pull request to Linus since around
> January 13th

Right! (I was mislead a bit by the numbered list at the beginning.;-)

Thanks,
Jarek P.
