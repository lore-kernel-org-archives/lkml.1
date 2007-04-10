Return-Path: <linux-kernel-owner+w=401wt.eu-S1753205AbXDJH5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbXDJH5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 03:57:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbXDJH5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 03:57:37 -0400
Received: from smtp101.sbc.mail.mud.yahoo.com ([68.142.198.200]:32613 "HELO
	smtp101.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753205AbXDJH5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 03:57:36 -0400
X-YMail-OSG: N.1doWYVM1mAV3ZlfVghooCxAiUjE_cLs2oh7BoYe0_R8nuknClnFkzStrQiLpZt5Sg4J8MeS86PtIsDyX.OeD_fH65t2tsXBvtEvhDc2bOXuUxzTzY1OV9.EuB3Gg--
Date: Tue, 10 Apr 2007 00:57:33 -0700
From: Chris Wedgwood <cw@f00f.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Greg KH <greg@kroah.com>, Ayaz Abdulla <aabdulla@nvidia.com>,
       Ingo Molnar <mingo@elte.hu>, "David S. Miller" <davem@davemloft.net>
Subject: Re: Linux 2.6.21-rc6
Message-ID: <20070410075733.GA30886@tuatara.stupidest.org>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org> <20070408160954.edd248d1.akpm@linux-foundation.org> <46198FD7.5000900@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46198FD7.5000900@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 08, 2007 at 08:59:03PM -0400, Jeff Garzik wrote:

> >ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc6/2.6.21-rc6-mm1/broken-out/forcedeth-work-around-null-skb-dereference-crash.patch
>
> It sounded this was specific to Ingo.

I'm not sure, it sounds a bit like something I saw a while ago.  I
would have to check for sure, I made a quick debugging patch (sent to
netdev) and it went away so I think my last though was a
miscompilation.

