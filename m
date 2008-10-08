Return-Path: <linux-kernel-owner+w=401wt.eu-S1756887AbYJHWDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887AbYJHWDv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 18:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754809AbYJHWDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 18:03:42 -0400
Received: from 57.Red-88-2-100.staticIP.rima-tde.net ([88.2.100.57]:39061 "EHLO
	mail.leals.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602AbYJHWDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 18:03:42 -0400
X-Greylist: delayed 606 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Oct 2008 18:03:41 EDT
From: Davi Leal <davi@leals.com>
To: linux-kernel@vger.kernel.org
Subject: free tg3 ethernet driver
Date: Wed, 8 Oct 2008 23:53:30 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810082353.31033.davi@leals.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We would like to have a tg3 driver which would be accepted as free by the 
FSF's standards.

At least some part of the driver seems to be GPL'ed; see [1].  However, the 
FSF's hardware guide lists tg3 as non-free, so there seems to be a non-free 
firmware somewhere.

 [1]
 http://www.broadcom.com/support/ethernet_nic/driver-sla.php?driver=570x-Linux


We would like to be able to use the free driver with Linux 2.6.27 or later.

Donation pledge group at
  http://gnuherds.org/pledges?id=58
Current donations: $101 USD
