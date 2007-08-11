Return-Path: <linux-kernel-owner+w=401wt.eu-S1757354AbXHKGvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354AbXHKGvV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 02:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752243AbXHKGvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 02:51:12 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:1221 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbXHKGvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 02:51:12 -0400
Date: Fri, 10 Aug 2007 23:51:08 -0700
From: divy@chelsio.com
Message-Id: <200708110651.l7B6p8v2008685@speedy5.asicdesigners.com>
To: jeff@garzik.org, netdev@vget.kernel.org
Subject: [PATCH 0/13] cxgb3 - driver updates
Cc: linux-kernel@vger.kernel.org, swise@opengridcomputing.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

I'm submitting a patch series for inclusion in netdev#upstream.

Here is a brief description:
-	MAC hang workaround update
-	Modify max HW Rx coalescing size
-	Log SGE doorbell Fifo overflow
-	Use Tx immediate data for offload packets whenever possible
-	RDMA can get internal mem info to workaround HW issues
-	More validity checks on connection ids
-	Stop MAC when a fatal error is detected
-	Log HW serial number
-	Update internal mem operating mode
-	Update engine microcode management, version is now 1.1.0
-	Update FW management, version is now 4.6.0
-	Ignore some HW errors until the HW is initialized
-	Check MSI/MSI-X after it got enabled

Cheers,
Divy
