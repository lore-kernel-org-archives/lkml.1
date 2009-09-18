Return-Path: <linux-kernel-owner+w=401wt.eu-S1754194AbZIRUpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbZIRUpA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 16:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758231AbZIRUo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 16:44:57 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44580 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758230AbZIRUo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 16:44:57 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Fri, 18 Sep 2009 22:44:42 +0200
Message-Id: <1253306686-20616-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.6.3.3
X-SA-Exim-Connect-IP: 92.198.50.58
X-SA-Exim-Mail-From: w.sang@pengutronix.de
Subject: Lightweight patchset for regulator-framework
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is a small patch series fixing a few issues I found while working on a
regulator driver. Might be nice to have in 2.6.32 already.

Regards,

   Wolfram

