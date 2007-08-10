Return-Path: <linux-kernel-owner+w=401wt.eu-S941767AbXHJU4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941767AbXHJU4a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 16:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760309AbXHJU4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 16:56:20 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:37683 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758882AbXHJU4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 16:56:19 -0400
Message-ID: <46BCD0F1.8040006@garzik.org>
Date: Fri, 10 Aug 2007 16:56:17 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: netdev@vger.kernel.org, davem@davemloft.net
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] Add ETHTOOL_[GS]FLAGS sub-ioctls
References: <20070810202426.GA25050@havoc.gtf.org>
In-Reply-To: <20070810202426.GA25050@havoc.gtf.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

All this is currently checked into the 'eflags' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git

But when everybody is happy with it, IMO we should get it into 
net-2.6.24.git, as it enables LRO.

	Jeff


