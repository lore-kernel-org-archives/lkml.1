Return-Path: <linux-kernel-owner+w=401wt.eu-S1758898AbXJ2Sqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898AbXJ2Sqr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 14:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbXJ2Sqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 14:46:38 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:55233 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbXJ2Sqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 14:46:37 -0400
Subject: 2.6.23.1-rt5
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Mon, 29 Oct 2007 14:46:09 -0400
Message-Id: <1193683569.5623.38.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the 2.6.23.1-rt5 tree, which can be
downloaded from the location:

 http://www.kernel.org/pub/linux/kernel/projects/rt/

Changes since 2.6.23-rt4

  - Compile for UP (Discovered by Dragan Noveski)

  - ntfs local_irq_save_nort (Mike Galbraith)

  - Don't disable preemption on handlers without IST (Andi Kleen)

  - Minor cleanups (Steven Rostedt)

to build a 2.6.23.1-rt5 tree, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.23.1.tar.bz2 
  http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.23.1-rt5.bz2

The broken out patches are also available.

-- Steve

