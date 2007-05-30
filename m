Return-Path: <linux-kernel-owner+w=401wt.eu-S1756014AbXE3RAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbXE3RAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 13:00:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753870AbXE3RAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 13:00:07 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:3492 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257AbXE3RAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 13:00:05 -0400
Message-ID: <465DAD8D.9030600@chelsio.com>
Date: Wed, 30 May 2007 09:59:57 -0700
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>, netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH 2.6.22 0/5] 
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 May 2007 16:59:38.0527 (UTC) FILETIME=[E87B22F0:01C7A2DB]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

I'm submitting a set of bug fixes for inclusion in 2.6.22.
The patches are built against Linus'git tree.

Here is a brief description:
- Fix skb->dev dereference in,
- Fix netpoll handler,
- Fix link status detection for direct XAUI adapters,
- Work around potential hang on MTU change,
- Fix MAC watchdog.

You have already ACK'ed the link status detection fix.
I'm not sure however where it stands in your queue, so I'm resubmitting it.
Please ignore if you already processed it.

Cheers,
Divy
