Return-Path: <linux-kernel-owner+w=401wt.eu-S1752861AbZIYWSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbZIYWSt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 18:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbZIYWSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 18:18:48 -0400
Received: from stargate.chelsio.com ([67.207.112.58]:8029 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbZIYWSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 18:18:47 -0400
From: kxie@chelsio.com
Message-Id: <200909252225.n8PMPaqI031748@localhost.localdomain>
Date: Fri, 25 Sep 2009 15:25:36 -0700
To: michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com,
       davem@davemloft.net
Subject: [PATCH v2 0/2] cxgb3/cxgb3i: added support of private MAC address and provisioning packet handler for iSCSI
Cc: swise@opengridcomputing.com, divy@chelsio.com, rakesh@chelsio.com,
       kxie@chelsio.com, linux-scsi@vger.kernel.org,
       open-iscsi@googlegroups.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Karen Xie <kxie@chelsio.com>

The two patches added support of private MAC address, which is derived from
the network (i.e., public) MAC address, and provisioning packet handler for
iSCSI traffic only.

Best regards,
Karen
