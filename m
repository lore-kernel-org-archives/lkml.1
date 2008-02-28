Return-Path: <linux-kernel-owner+w=401wt.eu-S1764925AbYB1Tzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764925AbYB1Tzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 14:55:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761464AbYB1Tuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 14:50:44 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:60149 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764200AbYB1Tum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 14:50:42 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 28 Feb 2008 20:50:26 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 0/4] firewire: trivial fw-sbp2 updates
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.efdb1b5f8ccb3cbd@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll follow up with four simple fw-sbp2 patches:

 1/4 firewire: fw-sbp2: remove usages of fw_memcpy_to_be32
 2/4 firewire: fw-sbp2: simplify some macros
 3/4 firewire: fw-sbp2: remove unnecessary memset
 4/4 firewire: fw-sbp2: reduce log noise

 drivers/firewire/fw-sbp2.c |  110 ++++++++++++++-----------------------
 1 file changed, 44 insertions(+), 66 deletions(-)
-- 
Stefan Richter
-=====-==--- --=- ===--
http://arcgraph.de/sr/

