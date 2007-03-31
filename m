Return-Path: <linux-kernel-owner+w=401wt.eu-S1750712AbXCaHNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750712AbXCaHNG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 03:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750987AbXCaHNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 03:13:05 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:27835 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbXCaHNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 03:13:04 -0400
Message-ID: <460E09F2.80201@chelsio.com>
Date: Fri, 30 Mar 2007 23:12:50 -0800
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>, netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH 2.6.21 0/4] cxgb3 - bug fixes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Mar 2007 07:12:55.0832 (UTC) FILETIME=[01412980:01C77364]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

I'm submitting a set of bug fixes for inclusion in 2.6.21.
The patches are built against Linus'git tree.

Here is a brief description:
- Ensure that the on-board TCAM's active region size is always greater 
than 16
- the driver now recognizes NIC only adapters
- tighten the MAC hang workaround
- bump up firmware version

Cheers,
Divy
