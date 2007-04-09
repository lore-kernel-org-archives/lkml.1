Return-Path: <linux-kernel-owner+w=401wt.eu-S1752209AbXDIA7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbXDIA7J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 20:59:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbXDIA7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 20:59:09 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50797 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209AbXDIA7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 20:59:08 -0400
Message-ID: <46198FD7.5000900@garzik.org>
Date: Sun, 08 Apr 2007 20:59:03 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Greg KH <greg@kroah.com>, Ayaz Abdulla <aabdulla@nvidia.com>,
       Ingo Molnar <mingo@elte.hu>, "David S. Miller" <davem@davemloft.net>
Subject: Re: Linux 2.6.21-rc6
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org> <20070408160954.edd248d1.akpm@linux-foundation.org>
In-Reply-To: <20070408160954.edd248d1.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> netdev:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc6/2.6.21-rc6-mm1/broken-out/forcedeth-work-around-null-skb-dereference-crash.patch

It sounded this was specific to Ingo.  I haven't heard anybody else 
complain, and AFAIK Ayaz and Ingo were still going back and forth.


> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc6/2.6.21-rc6-mm1/broken-out/depcac-fix-handling-of-platorm_device_add-failure.patch

ACK this one.  Need to send this up, but I'm intentionally avoiding work 
as we are having a big Easter bash here in Raleigh.  Silly bunny-related 
traditions that have nothing to do with Jesus take priority ;-)

I have a couple other bug fixes to push, but that will wait until Tuesday.

	Jeff


