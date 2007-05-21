Return-Path: <linux-kernel-owner+w=401wt.eu-S1762323AbXEULAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762323AbXEULAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 07:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757130AbXEULAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 07:00:38 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:31219 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755714AbXEULAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 07:00:37 -0400
Message-Id: <20070521105118.955425052@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Mon, 21 May 2007 12:51:18 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [patch 0/5] s390 patches for 2.6.22-rc2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

5 patches for s390. Important are the two patches that wire up the
system calls utimesat, signald, timerfd and eventfd.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

