Return-Path: <linux-kernel-owner+w=401wt.eu-S1753121AbYLNUpB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbYLNUpB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 15:45:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbYLNUow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 15:44:52 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:38693 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbYLNUov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 15:44:51 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 14 Dec 2008 21:44:37 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 0/4] firewire: trivia
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.aa7114dbd92c6a7d@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following:
1/4 firewire: core: remove obsolete assertions
2/4 firewire: standardize a variable name
3/4 firewire: remove line breaks before function names
4/4 firewire: core: remove unused definitions

 drivers/firewire/fw-card.c        |   68 ++++---------
 drivers/firewire/fw-cdev.c        |  132 +++++++++++---------------
 drivers/firewire/fw-device.c      |   40 +++----
 drivers/firewire/fw-device.h      |    3
 drivers/firewire/fw-iso.c         |   40 +++----
 drivers/firewire/fw-ohci.c        |  151 +++++++++++++-----------------
 drivers/firewire/fw-sbp2.c        |   57 ++++-------
 drivers/firewire/fw-topology.c    |   28 ++---
 drivers/firewire/fw-topology.h    |   13 --
 drivers/firewire/fw-transaction.c |  117 ++++++++---------------
 drivers/firewire/fw-transaction.h |  121 +++++++-----------------
 11 files changed, 310 insertions(+), 460 deletions(-)
-- 
Stefan Richter
-=====-==--- ==-- -===-
http://arcgraph.de/sr/

