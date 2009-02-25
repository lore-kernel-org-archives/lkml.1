Return-Path: <linux-kernel-owner+w=401wt.eu-S1759738AbZBYPIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759738AbZBYPIv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 10:08:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752098AbZBYPId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 10:08:33 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:58460 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbZBYPIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 10:08:32 -0500
Message-Id: <20090225150622.529143164@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Wed, 25 Feb 2009 16:06:22 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch/s390 00/46] s390 features patches for 2.6.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,
there are 46 patches in the features branch of git390 for the
upcoming merge window of 2.6.30. Three highlights:

 * A new shutdown action for automatic ipl after dump.
 * Large volume support for the dasd driver.
 * High performance ficon support for the dasd driver.

The other patches are the usual collection of non-critical bug
fixes and cleanups. As always nitpicks and reviews are welcome.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

