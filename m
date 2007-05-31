Return-Path: <linux-kernel-owner+w=401wt.eu-S1760047AbXEaEKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760047AbXEaEKv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 00:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755415AbXEaEKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 00:10:39 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:8132 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759899AbXEaEKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 00:10:38 -0400
Message-ID: <465E4AB8.2000903@chelsio.com>
Date: Wed, 30 May 2007 21:10:32 -0700
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>, netdev@vger.kernel.org
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH 0/3] cxgb3 - Driver updates 
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 May 2007 04:10:13.0654 (UTC) FILETIME=[967C4B60:01C7A339]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

I'm submitting a patch series for inclusion in netdev#upstream.

Here is a brief description:
- update page management in the SGE code,
- update FW to 4.1 and proceed to subsequent HW tuning,
- allow microcode update without a power cycle.

Cheers,
Divy
