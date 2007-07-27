Return-Path: <linux-kernel-owner+w=401wt.eu-S935923AbXG0Lcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935923AbXG0Lcm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 07:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754937AbXG0Lcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 07:32:33 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:63310 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404AbXG0Lcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 07:32:32 -0400
Message-Id: <20070727113348.413110503@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jul 2007 13:33:48 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [patch 0/6] more s390 patches for 2.6.23-rc1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Six additional patches for the 2.6.23-rc1 update for s390.
The shortlog:

Cornelia Huck (3):
      [S390] cio: Clean up messages.
      [S390] cio: Make CIO_* macros safe if dbfs are not available.
      [S390] cio: Reorganize initialization.

Frank Munzert (1):
      [S390] vmur: fix diag14_read.

Heiko Carstens (2):
      [S390] Fix IRQ tracing.
      [S390] Fix sclp_vt220 error handling.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

