Return-Path: <linux-kernel-owner+w=401wt.eu-S1752535AbYLBPlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535AbYLBPlZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 10:41:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbYLBPkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 10:40:52 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:34939 "EHLO
	teyla.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751161AbYLBPkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 10:40:51 -0500
Message-Id: <20081202154018.906091477@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Tue, 02 Dec 2008 15:40:18 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: sdhci-devel@list.drzeus.cx, linux-kernel@vger.kernel.org,
       drzeus-sdhci@drzeus.cx
Subject: [patch 0/8] Update Samsung SDHCI
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an updated set of SDHCI patches to add support
for the Samsung S3C64XX and S3C2443 SoC range.

The DMA check is still in there, it hasn't been triggered
since getting the timeout clock wrong.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
