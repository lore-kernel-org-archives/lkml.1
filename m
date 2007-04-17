Return-Path: <linux-kernel-owner+w=401wt.eu-S1161293AbXDQSGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161293AbXDQSGO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 14:06:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161291AbXDQSGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 14:06:14 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:14081 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161280AbXDQSGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 14:06:13 -0400
Message-ID: <46250C8D.1010809@chelsio.com>
Date: Tue, 17 Apr 2007 11:06:05 -0700
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>, netdev@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH 2.6.21 0/3] cxgb3 - bug fixes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Apr 2007 18:06:08.0517 (UTC) FILETIME=[12F00B50:01C7811B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

I'm submitting a set of bug fixes for inclusion in 2.6.21.
The patches are built against Linus'git tree.

Here is a brief description:
- Fix resource usage in low memory conditions,
- PHY interrupts can use any GPIO pin.

Cheers,
Divy
