Return-Path: <linux-kernel-owner+w=401wt.eu-S1759967AbZGHF5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759967AbZGHF5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 01:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759510AbZGHF4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 01:56:25 -0400
Received: from stargate.chelsio.com ([67.207.112.58]:16310 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759526AbZGHF4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 01:56:24 -0400
Message-ID: <4A54332D.3010102@chelsio.com>
Date: Tue, 07 Jul 2009 22:48:29 -0700
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH 0/8 net-next-2.6] cxgb3: driver update
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Jul 2009 05:50:00.0843 (UTC) FILETIME=[EECA95B0:01C9FF8F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

I am submitting a series of 8 patches for inclusion in net-next-2.6.
Here is a brief description of the patch series:
- Drain the mac Tx fifo when a port goes down
- Fix the mac high water computation on T3C chips
- Fix LED settings and first link status report for the AEL2020 phy
- Minor fixes to the AQ100X phy
- Toggles Global Tx disable bit on phys when powered down
- Fix HW initialization for offload connections
- Fix MAC indexation for the Gen2 adapter
- use request_firmware() to load the phy EDC programming.

Cheers,
Divy
