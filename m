Return-Path: <linux-kernel-owner+w=401wt.eu-S1754501AbYHJVWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbYHJVWT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 17:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753684AbYHJVWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 17:22:10 -0400
Received: from the.earth.li ([217.147.81.2]:50167 "EHLO the.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753601AbYHJVWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 17:22:10 -0400
Date: Sun, 10 Aug 2008 18:22:07 -0300
From: Jonathan McDowell <noodles@earth.li>
To: =?iso-8859-1?B?RnLpZOlyaWMgTC4gVy4=?= Meunier <2@pervalidus.net>
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: X "Hangs" with RS690 + 2.6.26
Message-ID: <20080810212207.GC4977@earth.li>
References: <20080725094334.GC30002@earth.li> <alpine.DEB.0.82.0807251107400.30593@skynet.skynet.ie> <20080801160256.GV30002@earth.li> <alpine.LNX.1.10.0808090541320.4876@pervalidus> <20080810191823.GB4977@earth.li> <alpine.LNX.1.10.0808101722440.4876@pervalidus>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LNX.1.10.0808101722440.4876@pervalidus>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 10, 2008 at 05:25:55PM -0300, Frédéric L. W. Meunier wrote:
> On Sun, 10 Aug 2008, Jonathan McDowell wrote:
> >On Sat, Aug 09, 2008 at 05:47:42AM -0300, Frédéric L. W. Meunier wrote:
> >>I apparently have the same problem with my RS690. I noticed it after
> >>upgrading from 2.6.25 to 2.6.26, alongside xorg-server (1.4.99.904 to
> >>1.4.99.905) and Mesa (7.1-rc1 to 7.1-rc3). The ATI driver is 6.9.0.
> >>
> >>Here it always freezes in a few minutes or less than an hour.  When it
> >>happens, I'm not running any 3D application and the CPU is idle. I may
> >>be just typing something in a shell. But it works disabling DRI.
> >
> >Likewise, I'm not doing anything 3D related (at least, not consciously).
> 
> BTW, I forgot to mention that. Here the motherboard is a
> Gigabyte GA-MA69VM-S2. When it happens and I use SysRq to
> reboot, it doesn't post in the BIOS screen. I have to press
> reset.

My mobo is an ASUS M2A-VM HDMI and a "shutdown -r now" when X is wedged
(done over ssh) results in a clean reboot; no need to hard reset.

J.

-- 
] http://www.earth.li/~noodles/ [] 101 things you can't have too much  [
]  PGP/GPG Key @ the.earth.li   []     of : 38 - clean underwear.      [
] via keyserver, web or email.  []                                     [
] RSA: 4DC4E7FD / DSA: 5B430367 []                                     [
