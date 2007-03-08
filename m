Return-Path: <linux-kernel-owner+w=401wt.eu-S1751649AbXCHETS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649AbXCHETS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 23:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751652AbXCHETS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 23:19:18 -0500
Received: from smtp.osdl.org ([65.172.181.24]:47635 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648AbXCHETR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 23:19:17 -0500
Date: Wed, 7 Mar 2007 20:19:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.21-rc3-mm2
Message-Id: <20070307201915.4d579113.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc3/2.6.21-rc3-mm2/

- This is the same as 2.6.21-rc3-mm1, except Con's CPU scheduler changes
  were dropped.

  This is for A/B comparison purposes, and because those changes crashed on
  one test setup.



Changes since 2.6.21-rc3-mm1:

-lists-add-list-splice-tail.patch
-sched-remove-sleepavg-from-proc.patch
-sched-remove-noninteractive-flag.patch
-sched-implement-180-bit-sched-bitmap.patch
-sched-implement-rsdl-cpu-scheduler.patch
-sched-document-rsdl-cpu-scheduler.patch

 Removed.


