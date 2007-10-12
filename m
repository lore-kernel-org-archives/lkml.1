Return-Path: <linux-kernel-owner+w=401wt.eu-S1755048AbXJLCEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048AbXJLCEp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 22:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754423AbXJLCE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 22:04:29 -0400
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:54197 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238AbXJLCE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 22:04:27 -0400
Subject: 2.6.23-rt1
From: Steven Rostedt <rostedt@goodmis.org>
To: RT <linux-rt-users@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Date: Thu, 11 Oct 2007 22:04:00 -0400
Message-Id: <1192154640.15992.10.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the 2.6.23-rt1 tree, which can be
downloaded from the location:

 http://www.kernel.org/pub/linux/kernel/projects/rt/

Changes since 2.6.23-rc9-rt2

  - updated to 2.6.23

  - spin_trylock_irqsave macro fix (Sébastien Dugué)

  - move rcu_preempt_boost init earlier (Steven Rostedt)

  - rt task send IPI condition update (Mike Kravetz)


to build a 2.6.23-rt1 tree, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.23.tar.bz2
  http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.23-rt1.bz2

The broken out patches are also available.

-- Steve






