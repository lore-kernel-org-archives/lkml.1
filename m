Return-Path: <linux-kernel-owner+w=401wt.eu-S1753492AbYDLWij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbYDLWij (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 18:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754022AbYDLWia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 18:38:30 -0400
Received: from nonada.if.usp.br ([143.107.131.169]:53953 "EHLO
	nonada.if.usp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642AbYDLWi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 18:38:29 -0400
To: linux-kernel@vger.kernel.org
Subject: Root on partitionable raid.
Message-Id: <E1JkoMd-00028S-RL@nonada.if.usp.br>
From: Joao Luis Meloni Assirati <assirati@nonada.if.usp.br>
Date: Sat, 12 Apr 2008 19:38:27 -0300
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I tried to boot a 2.6.25-rc8 kernel with ext3, raid1 and sata compiled in (raid partitions marked as raid autodetect) and it cannot detect raid partitions in boot time (it could not find my root that is a raid1 partition). I did not test rc9, but by the changelog the problem did not got corrected.

2.6.24 works fine.

Thank you,
João.
