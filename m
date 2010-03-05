Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab0CEOqp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 09:46:45 -0500
Received: from mail.gmx.net ([213.165.64.20]:43782 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751727Ab0CEOqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 09:46:44 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX189+KUe2UY9AP9P8182eC23VQXM5mYhTDo/WuZuXI
	vgNGRZ+a3IT4Ep
Subject: Re: [git pull] drm request 3
From: Mike Galbraith <efault@gmx.de>
To: David Miller <davem@davemloft.net>
Cc: alan@lxorguk.ukuu.org.uk, mingo@elte.hu, skeggsb@gmail.com,
       torvalds@linux-foundation.org, airlied@gmail.com, airlied@linux.ie,
       linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
       dri-devel@lists.sf.net
In-Reply-To: <20100305.063718.211238119.davem@davemloft.net>
References: <1267748927.3496.6.camel@nisroch>
	 <20100305064955.GA6453@elte.hu>
	 <20100305123834.0d9c6277@lxorguk.ukuu.org.uk>
	 <20100305.063718.211238119.davem@davemloft.net>
Content-Type: text/plain
Date: Fri, 05 Mar 2010 15:46:39 +0100
Message-Id: <1267800399.6681.67.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.56999999999999995
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-05 at 06:37 -0800, David Miller wrote:
> From: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Date: Fri, 5 Mar 2010 12:38:34 +0000
> 
> >> The conclusion is crystal clear, breaking an ABI via a "flag day" 
> >> cleanup/feature/etc is:
> > 
> > Ingo go read the staging Kconfig. It's crystal clear, and lots of vendor
> > junk that is in there being cleaned up it would be *insane* to keep their
> > old APIs
> > 
> > See there's a bigger offence than breaking an ABI - its called not RTFM.
> 
> All of this RTFM and what directory the noveau driver is sitting in is
> entirely irrelevant Alan.
> 
> If it effects such a large number of people, which this noveau thing
> does, it's entirely relevant to everyone.  And the way it's breaking
> and making kernel development difficult for so many people matters to
> us.
> 
> It's about the tester base, and this breakage shrinks the tester base
> considerably.
> 
> Or do you want the kernel tested by less people?

On the bright side, all this hubbub sends a very positive message to the
noveau development crew.  Folks, your work is important.  I'd be proud
as a peacock :)

	-Mike

