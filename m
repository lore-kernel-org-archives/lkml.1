Return-Path: <linux-kernel-owner+w=401wt.eu-S1754876AbXH2EI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbXH2EI3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 00:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750737AbXH2EIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 00:08:19 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:6795 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbXH2EIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 00:08:18 -0400
Message-ID: <46D4F12C.7090409@chelsio.com>
Date: Tue, 28 Aug 2007 21:08:12 -0700
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>, Roland Dreier <rdreier@cisco.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH 2.6.23 0/2] cxgb3 - Fix dev->priv usage
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Aug 2007 04:06:50.0557 (UTC) FILETIME=[069BA6D0:01C7E9F2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff/Roland,

I'm resubmitting the cxgb3 dev->priv fix for inclusion in 2.6.23.
I also submit a follow-up patch for the iw_cxgb3 driver that fixes
the previous infiniband breakage.

Cheers,
Divy
