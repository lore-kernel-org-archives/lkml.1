Return-Path: <linux-kernel-owner+w=401wt.eu-S2992581AbXCWV4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992581AbXCWV4g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 17:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992580AbXCWV4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 17:56:36 -0400
Received: from mail.gmx.net ([213.165.64.20]:51640 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934325AbXCWV4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 17:56:33 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/44J1+eqf4cGZFbHa1gXTnXd2cWkaOAgIlZHtaGG
	2ASNmF8IJQ2KZl
Date: Fri, 23 Mar 2007 22:56:31 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Jeff Garzik <jeff@garzik.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] net driver fixes
In-Reply-To: <20070323065742.GA17613@havoc.gtf.org>
Message-ID: <Pine.LNX.4.60.0703232254170.5971@poirot.grange>
References: <20070323065742.GA17613@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff, might be worth getting the sk_buff leak fix in ppp from 
http://www.spinics.net/lists/netdev/msg27706.html in 2.6.21 too?

Don't know how important it is for stable. It was present in 2.6.18 too.

Thanks
Guennadi
---
Guennadi Liakhovetski
