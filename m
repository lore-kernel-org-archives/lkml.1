Return-Path: <linux-kernel-owner+w=401wt.eu-S1764534AbXJRA6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764534AbXJRA6X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 20:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932544AbXJRA5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 20:57:42 -0400
Received: from clem.clem-digital.net ([68.16.168.10]:55789 "EHLO
	clem.clem-digital.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932424AbXJRA5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 20:57:42 -0400
X-Greylist: delayed 1323 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Oct 2007 20:57:41 EDT
From: Pete Clements <clem@clem.clem-digital.net>
Message-Id: <200710180035.l9I0Zbqw003707@clem.clem-digital.net>
Subject: 23-git12 Kernel panic blk_rq_map_sg
To: linux-kernel@vger.kernel.org (linux-kernel)
Date: Wed, 17 Oct 2007 20:35:37 -0400 (EDT)
X-Mailer: ELM [version 2.5 PL7]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-git12 panics. Here's the short bit

EIP:[<c01f5783>] blk_rq_map_sg+073/0x160 SS:ESP 0068:c2dc3df8
Kernel panic - not syncing: Fatal exception in interrupt
-- 
Pete Clements 
