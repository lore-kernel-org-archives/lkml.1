Return-Path: <linux-kernel-owner+w=401wt.eu-S1756829AbXHWGg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829AbXHWGg6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 02:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753526AbXHWGgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 02:36:48 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:4598 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186AbXHWGgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 02:36:47 -0400
Message-ID: <46CD2AA8.9070507@chelsio.com>
Date: Wed, 22 Aug 2007 23:35:20 -0700
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH 0/3] cxgb3 driver update
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Aug 2007 06:35:22.0212 (UTC) FILETIME=[C7E3CA40:01C7E54F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

I'm submitting three more patches for inclusion in netdev#upstream.
These patches are built over the series I resent yesterday night.
The patch numbering reflects the stacking.

Here is a brief description:
-   avoid false positives in the xgmac hang workaround
-   Properly set the CQ_ERR bit in RDMA CQ contexts.
-   Update CQ context operations time out values

Cheers,
Divy


