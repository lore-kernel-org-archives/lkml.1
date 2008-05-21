Return-Path: <linux-kernel-owner+w=401wt.eu-S932339AbYEUB5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339AbYEUB5e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 21:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756920AbYEUB5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 21:57:22 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:9210 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756169AbYEUB5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 21:57:21 -0400
Message-ID: <4833817D.2060305@chelsio.com>
Date: Tue, 20 May 2008 18:57:17 -0700
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>, NetDev <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH 0/3 2.6.27] cxgb3 - driver updates
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 May 2008 01:56:46.0218 (UTC) FILETIME=[ECBD86A0:01C8BAE5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

I'm submitting 3 update patches against netdev-2.6#upstream for 
inclusion in 2.6.27.
Here is a brief description of the patch series:
- Check pci mapping errors
- Feed the Jumbo frame Rx queue with pages
- Add support for LRO

Cheers,
Divy
