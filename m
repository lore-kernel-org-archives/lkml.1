Return-Path: <linux-kernel-owner+w=401wt.eu-S1753979AbXJ0DQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979AbXJ0DQx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 23:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbXJ0DQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 23:16:45 -0400
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:65094 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbXJ0DQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 23:16:44 -0400
Subject: 2.6.23.1-rt4
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Fri, 26 Oct 2007 23:16:31 -0400
Message-Id: <1193454991.5623.27.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the 2.6.23.1-rt4 tree, which can be
downloaded from the location:

 http://www.kernel.org/pub/linux/kernel/projects/rt/

Changes since 2.6.23-rt3

  - Updated to stable release 2.6.23.1

  - Added latest High Resolution timers work

  - RT Balance CPU weight optimization (Gregory Haskins)

  - Limit to NUMA Node RT Balance (Steven Rostedt)

  - Workqueue PI sched.h compile fix (Clark Williams)

  - plist debug init fix (Jan Kiszka)

  - Kconfig updates (Carsten Emde)

  - IRQ flags recalculation fix (Paul Gortmaker)

to build a 2.6.23-rt3 tree, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.23.1.tar.bz2
  http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.23.1-rt4.bz2

The broken out patches are also available.

-- Steve


