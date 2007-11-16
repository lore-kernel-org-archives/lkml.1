Return-Path: <linux-kernel-owner+w=401wt.eu-S1762196AbXKPTVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762196AbXKPTVu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 14:21:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754064AbXKPTVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 14:21:37 -0500
Received: from stargate.chelsio.com ([12.22.49.110]:20404 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbXKPTVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 14:21:36 -0500
Message-ID: <473DED5B.5070802@chelsio.com>
Date: Fri, 16 Nov 2007 11:19:55 -0800
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Steve Wise <swise@opengridcomputing.com>,
       Wen Xiong <wenxiong@us.ibm.com>
Subject: [PATCH 0/9] cxgb3 - driver update
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Nov 2007 19:20:02.0718 (UTC) FILETIME=[AFEA2BE0:01C82885]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff, Dave,

I'm submitting a patch series for inclusion in 2.6.25.
The patches are built against netdev#upstream.

Here is a brief description:
- Fix error path when requesting MSI-X resources
- Use wild card for PCI Vendor ID
- Fix sysfs resource release
- Add PCI error recovery support
- FW upgrade
- Fix interaction with pktgen
- Remove unused argument in sysfs related methods
- HW setup update
- Synchronize I/O access on Tx path

Cheers,
Divy


