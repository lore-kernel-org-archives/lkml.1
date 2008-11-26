Return-Path: <linux-kernel-owner+w=401wt.eu-S1754584AbYKZUh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbYKZUh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 15:37:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbYKZUhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 15:37:13 -0500
Received: from stargate.chelsio.com ([12.22.49.110]:11184 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746AbYKZUhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 15:37:12 -0500
Message-ID: <492DB369.3020505@chelsio.com>
Date: Wed, 26 Nov 2008 12:36:57 -0800
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>, netdev@vger.kernel.org
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH 0/4 2.6.29] cxgb3 - driver updates
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Nov 2008 20:37:08.0781 (UTC) FILETIME=[C0955DD0:01C95006]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cc-ing Dave in Jeff's absence]

Hi Jeff,

I'm submitting 4 update patches against net-next-2.6 for inclusion in 
2.6.29.
Here is a brief description of the patch series:
- add missing ndo_start_xmit setting
- fix parameter checking in memory allocation routine
- include firmware and protocol engine images in the firmware/ directory
- update firmware and protocol engine images lookup path

Cheers,
Divy
