Return-Path: <linux-kernel-owner+w=401wt.eu-S932088AbYCDQbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088AbYCDQbj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 11:31:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764972AbYCDQad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 11:30:33 -0500
Received: from pecan.exetel.com.au ([220.233.0.17]:48594 "EHLO
	smtp.po.exetel.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765424AbYCDQab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:30:31 -0500
X-Greylist: delayed 1677 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Mar 2008 11:30:31 EST
From: oakad@exemail.com.au
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: MemoryStick driver updates
Date: Wed,  5 Mar 2008 03:02:17 +1100
Message-Id: <1204646548-27466-1-git-send-email-oakad@exemail.com.au>
X-Mailer: git-send-email 1.5.3.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch series consists of the following:
1. Important (data corruption) fix to the tifm memorystick backend
2. Initial commit of JMicron memorystick backend
3. Some additional minor updates, including much better bitfield defines
