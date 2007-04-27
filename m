Return-Path: <linux-kernel-owner+w=401wt.eu-S1755854AbXD0OFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854AbXD0OFr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 10:05:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755899AbXD0OFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 10:05:47 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:20284 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755854AbXD0OEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 10:04:53 -0400
Message-Id: <20070427140503.087958775@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Fri, 27 Apr 2007 16:05:03 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [patch 00/38] s390 patches for 2.6.22
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is the s390 patchset for the merge window of 2.6.22.
Most of it is cleanup and bug-fixes, but there are some
new features as well:
 - Channel path configure function.
 - Improved oops output with an in-kernel disassembler
 - Make use of generic bug.
 - zfcpdump support.
 - Processor degradation notification.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

