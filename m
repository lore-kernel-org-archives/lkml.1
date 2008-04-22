Return-Path: <linux-kernel-owner+w=401wt.eu-S1763126AbYDVSuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763126AbYDVSuM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 14:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755427AbYDVStz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 14:49:55 -0400
Received: from brick.kernel.dk ([87.55.233.238]:27572 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754650AbYDVSty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 14:49:54 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, npiggin@suse.de,
       torvalds@linux-foundation.org
Cc: peterz@infradead.org, sam@ravnborg.org
Subject: [PATCH 0/11] Generic smp_call_function() #2
Date: Tue, 22 Apr 2008 20:50:16 +0200
Message-Id: <1208890227-24808-1-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.5.1.57.g5909c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

OK, so here's version #2 of the patchset. Changes since the last
posting:

- Better Kconfig setup, thanks Sam.
- Fix data leak, thanks Linus.
- Misplaced sparc64 bit in the s390 patch, thanks Martin.
- Arm should work, thanks Catalin.

-- 
Jens Axboe


