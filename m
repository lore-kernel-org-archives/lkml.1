Return-Path: <linux-kernel-owner+w=401wt.eu-S1754772AbXEZW7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772AbXEZW7e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 18:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751352AbXEZW7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 18:59:25 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:11188 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbXEZW7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 18:59:24 -0400
Message-ID: <4658BBC0.3050907@chelsio.com>
Date: Sat, 26 May 2007 15:59:12 -0700
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>, netdev@vger.kernel.org
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH 2.6.22 0/7] cxgb3 - bug fixes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 May 2007 22:58:55.0258 (UTC) FILETIME=[6FA43FA0:01C79FE9]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

I'm submitting a set of bug fixes for inclusion in 2.6.22.
The patches are built against Linus'git tree.

Here is a brief description:
- Fix page management in the SGE code,
- Fix netpoll handler,
- Fix link status detection for direct XAUI adapters,
- Update FW to 4.1 and proceed to subsequent HW tuning,
- Work around potential hang on MTU change,
- Fix MAC watchdog,
- Allow microcode update without a power cycle.

Cheers,
Divy
