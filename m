Return-Path: <linux-kernel-owner+w=401wt.eu-S1030581AbXCHJ7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030581AbXCHJ7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 04:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030616AbXCHJ7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 04:59:20 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:45003 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030581AbXCHJ7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 04:59:19 -0500
Message-ID: <45EFDE75.5060905@garzik.org>
Date: Thu, 08 Mar 2007 04:59:17 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: ext4, wireless (was Re: 2.6.21-rc3-mm1)
References: <20070307201839.6f45735b.akpm@linux-foundation.org>
In-Reply-To: <20070307201839.6f45735b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> - The wireless changes in here need a lot of testers, please.  It is major
>   rework.
> 
>   Of course the config files got all changed around so `make oldconfig'
>   breaks everything.  I was able to get ipw2200 working after some fumbling,
>   but perhaps John can tell people what has been changed in there?  What has
>   happened, from a big picture perspective?

The big big pictures is that Linux is getting a new wireless stack, one 
that active developers seem to agree on.  It /should/ support all the 
old wireless-tools binaries out there, except the wext/netlink stuff 
that people want to kill.


> - Re-added the ext4 development tree to the -mm lineup.  It has stuff in
>   it.  

IMO I've been a bit disappointed at the rate of development.  I had 
hoped that patches to ext4 would be making it into mainline more rapidly.

	Jeff


