Return-Path: <linux-kernel-owner+w=401wt.eu-S1755316AbZAXSmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316AbZAXSmc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 13:42:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754918AbZAXSl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 13:41:59 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:57511 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415AbZAXSl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 13:41:57 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 24 Jan 2009 19:41:46 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 0/7] ieee1394 + firewire: misc sbp2 updates
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.6fe4fe5b72231863@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following up:

[PATCH 1/7] firewire: sbp2: fix payload limit at S1600 and S3200
[PATCH 2/7] firewire: sbp2: define some magic numbers as macros
[PATCH 3/7] ieee1394: sbp2: fix payload limit at S1600 and S3200
[PATCH 4/7] ieee1394: sbp2: don't assume zero model_id or firmware_revision if there is none
[PATCH 5/7] ieee1394: sbp2: follow up to "ieee1394: inherit ud vendor_id from node vendor_id"
[PATCH RFT 6/7] ieee1394: sbp2: add workarounds for 2nd and 3rd generation iPods
[PATCH RFT 7/7] firewire: sbp2: add workarounds for 2nd and 3rd generation iPods

 drivers/firewire/fw-sbp2.c |   73 +++++++++++++++++++++----------------
 drivers/ieee1394/sbp2.c    |   60 +++++++++++++++++++-----------
 drivers/ieee1394/sbp2.h    |    1 
 3 files changed, 83 insertions(+), 51 deletions(-)
-- 
Stefan Richter
-=====-==--= ---= ==---
http://arcgraph.de/sr/

