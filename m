Return-Path: <linux-kernel-owner+w=401wt.eu-S1756738AbYFSFoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738AbYFSFoW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 01:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbYFSFn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 01:43:59 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:19851 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbYFSFn6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 01:43:58 -0400
X-Greylist: delayed 1828 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Jun 2008 01:43:58 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH 0/3 2.6.27] cxgb3i: Add iSCSI driver
Date: Wed, 18 Jun 2008 22:10:00 -0700
Message-ID: <8A71B368A89016469F72CD08050AD334D7128B@maui.asicdesigners.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 0/3 2.6.27] cxgb3i: Add iSCSI driver
Thread-Index: AcjRuEbMSDVI8dqBT1mcAKnJMU4r+AAD2+0n
References: <8A71B368A89016469F72CD08050AD334D71285@maui.asicdesigners.com>
From: "Karen Xie" <kxie@chelsio.com>
To: <michaelc@cs.wisc.edu>, "Divy Le Ray" <divy@chelsio.com>
Cc: <netdev@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
       <open-iscsi@googlegroups.com>, <linux-kernel@vger.kernel.org>,
       <security@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please review the iSCSI drivers for Chelsio CXGB3 (S3XX) devices.  

Here is a brief description of the patch series:
- added iscsi support to cxgb3 driver
- added pdu digest offload and payload direct-placement support to open-iscsi
- the cxgb3i iscsi driver

Thanks.

















