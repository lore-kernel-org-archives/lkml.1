Return-Path: <linux-kernel-owner+w=401wt.eu-S934465AbXEMQYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934465AbXEMQYA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 12:24:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757751AbXEMQXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 12:23:54 -0400
Received: from clem.clem-digital.net ([68.16.168.10]:33607 "EHLO
	clem.clem-digital.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709AbXEMQXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 12:23:53 -0400
From: Pete Clements <clem@clem.clem-digital.net>
Message-Id: <200705131623.l4DGNqta003015@clem.clem-digital.net>
Subject: 2.6.22-rc1 lost snd_4236 device
To: linux-kernel@vger.kernel.org (linux-kernel)
Date: Sun, 13 May 2007 12:23:52 -0400 (EDT)
X-Mailer: ELM [version 2.5 PL7]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fyi:
With 2.6.22-rc1 get following when loading sound device module. Introduced
with 2.6.21-git16.

FATAL: Error inserting snd_cs4236 (/lib/modules/2.6.22-rc1/kernel/sound/isa/cs423x/snd-cs4236.ko): No such device
FATAL: Error running install command for snd_cs4236

-- 
Pete Clements 
