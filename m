Return-Path: <linux-kernel-owner+w=401wt.eu-S1761652AbXJXRHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761652AbXJXRHz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 13:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753855AbXJXRHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 13:07:44 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:51082 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679AbXJXRHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 13:07:43 -0400
Subject: 2.6.23-rt2
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Wed, 24 Oct 2007 13:07:14 -0400
Message-Id: <1193245634.20679.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the 2.6.23-rt2 tree, which can be
downloaded from the location:

 http://www.kernel.org/pub/linux/kernel/projects/rt/

Changes since 2.6.23-rt1

  - Improved RT balancing (Steven Rostedt
                 with thanks to Gregory Haskins for some ideas)

  - plist debug fix (Arnaldo Carvalho de Melo)

  - seqlock irq fix (Daniel Walker)

  - slab NUMA freeing (Andi Kleen)


to build a 2.6.23-rt2 tree, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.23.tar.bz2
  http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.23-rt2.bz2

The broken out patches are also available.

-- Steve







