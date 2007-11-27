Return-Path: <linux-kernel-owner+w=401wt.eu-S1759808AbXK0V2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759808AbXK0V2l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 16:28:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758055AbXK0V2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 16:28:32 -0500
Received: from stargate.chelsio.com ([12.22.49.110]:12701 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757588AbXK0V2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 16:28:31 -0500
Message-ID: <474C8BF8.9080609@chelsio.com>
Date: Tue, 27 Nov 2007 13:28:24 -0800
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>, NetDev <netdev@vger.kernel.org>,
       linux-kernel@vger.kernel.org
CC: Ben Greear <greearb@candelatech.com>
Subject: [PATCH 0/3] cxgb - driver fixes.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Nov 2007 21:27:02.0671 (UTC) FILETIME=[404DF9F0:01C8313C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff,

I'm submitting a patch series for inclusion in 2.6.24 for the cxgb driver.
The patches are built against Linus'git tree.

Here is a brief description:
- Ensure that GSO skbs have enough headroom before encapsulating them,
- Fix a crash in NAPI mode,
- Fix statistics accounting and report.

Cheers,
Divy


