Return-Path: <linux-kernel-owner+w=401wt.eu-S1759337AbYBXFtN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759337AbYBXFtN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 00:49:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbYBXFs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 00:48:59 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:43654 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753641AbYBXFs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 00:48:58 -0500
Message-ID: <47C10546.7050508@garzik.org>
Date: Sun, 24 Feb 2008 00:48:54 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: romieu@fr.zoreil.com, bfields@fieldses.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [git patches] net driver fixes
References: <20080220212302.GJ30160@fieldses.org>	<20080220.134257.41491836.davem@davemloft.net>	<20080220224053.GA8500@electric-eye.fr.zoreil.com> <20080220.150753.17432290.davem@davemloft.net>
In-Reply-To: <20080220.150753.17432290.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> Jeff, I really don't want to pull that tree in.  Please trust me as
> your upstream to handle merging issues, as needed.


I trust you...  Otherwise I wouldn't have volunteered to move my 
upstream from Linus to you :)

My main issues/motivations were:

* quite simply, just force of habit:  I'm used to basing off of a recent 
Linus tree, to guarantee build&boot testing against the latest.

* worry about testing against a too-old tree, where non-networking fixes 
may have a relevant impact on my to-be-pushed netdrvr fixes.

But in this case it's fair to say there are no such issues, and it was 
mainly just out of habit.

So (as you saw in last email)... rebased and resend.

	Jeff


