Return-Path: <linux-kernel-owner+w=401wt.eu-S1760625AbXJXXC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760625AbXJXXC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 19:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753995AbXJXXCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 19:02:17 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:64956 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbXJXXCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 19:02:16 -0400
Subject: 2.6.23-rt3
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Wed, 24 Oct 2007 17:30:45 -0400
Message-Id: <1193261445.20679.12.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the 2.6.23-rt3 tree, which can be
downloaded from the location:

 http://www.kernel.org/pub/linux/kernel/projects/rt/

Changes since 2.6.23-rt2

  - Workqueue PI (Peter Zijlstra with help from Daniel Walker)

  - some schedstat updates (Steven Rostedt)

to build a 2.6.23-rt3 tree, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.23.tar.bz2
  http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.23-rt3.bz2

The broken out patches are also available.

-- Steve




