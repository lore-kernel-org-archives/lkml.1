Return-Path: <linux-kernel-owner+w=401wt.eu-S933473AbXKPOZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933473AbXKPOZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 09:25:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760436AbXKPOZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 09:25:28 -0500
Received: from mtagate7.de.ibm.com ([195.212.29.156]:54506 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755686AbXKPOZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 09:25:27 -0500
Message-Id: <20071116142441.484714036@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Fri, 16 Nov 2007 15:24:41 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [patch 00/10] 2.6.24-rc s390 patch queue
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These are the s390 patches in the queue for 2.6.24-rc. I plan to send
a please pull sometime next week. The shortlog:

Christian Borntraeger (2):
      [S390] magic sysrq: check for in_atomic before doing an console_unblank
      [S390] Optimize storage key handling for anonymous pages

Christoph Lameter (1):
      [S390] Explicitly code allocpercpu calls in iucv

Heiko Carstens (6):
      [S390] Fix irq tracing and lockdep_sys_exit calls.
      [S390] cmm: remove unused binary sysctls.
      [S390] appldata: remove unused binary sysctls.
      [S390] Fix kernel preemption.
      [S390] Dont overwrite lowcores on smp_send_stop().
      [S390] Fix memory detection.

Peter Oberparleiter (1):
      [S390] cio: change device sense procedure to work with pav aliases

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

