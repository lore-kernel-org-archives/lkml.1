Return-Path: <linux-kernel-owner+w=401wt.eu-S1753527AbXLESP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbXLESP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 13:15:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbXLESPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 13:15:09 -0500
Received: from stargate.chelsio.com ([12.22.49.110]:27223 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbXLESPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 13:15:07 -0500
Message-ID: <4756EA9D.1070204@chelsio.com>
Date: Wed, 05 Dec 2007 10:14:53 -0800
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>, netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Steve Wise <swise@opengridcomputing.com>,
       Wen Xiong <wenxiong@us.ibm.com>
Subject: [PATCH 0/2] cxgb3 - driver update
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Dec 2007 18:13:35.0453 (UTC) FILETIME=[8D2B10D0:01C8376A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff,

I'm submitting a patch series for inclusion in 2.6.25.
The patches are built against netdev#upstream.

Here is a brief description:
- Update GPIO pinning and MAC support for T3C adapters
- Enable parity error detection.

Cheers,
Divy

