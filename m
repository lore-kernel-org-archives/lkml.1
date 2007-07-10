Return-Path: <linux-kernel-owner+w=401wt.eu-S1757360AbXGJOBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360AbXGJOBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 10:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756605AbXGJOBC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 10:01:02 -0400
Received: from mx0.towertech.it ([213.215.222.73]:56674 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756356AbXGJOBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 10:01:00 -0400
Date: Tue, 10 Jul 2007 16:00:56 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: tglx@linutronix.de, Tim Gardner <tim.gardner@canonical.com>
Subject: acpi regression on some laptops
Message-ID: <20070710160056.443ae9ae@i1501.lan.towertech.it>
Organization: Tower Technologies
X-Mailer: Sylpheed
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



 Hello,

   with respect to commit e9e2cdb412412326c4827fc78ba27f410d837e6e 
 and the thread at [1] I just wanted to let you all know that
 the problem is still present :)

 I tried several combo of options, but only acpi=off or acpi=ht
 will let the PC boot.

 I'm trying to debug it.. any help/pointers are appreciated. I dont't
 have a deep knowledge of the subsystems involved.
 

[1]
  http://lkml.org/lkml/2007/6/21/360

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

