Return-Path: <linux-kernel-owner+w=401wt.eu-S1758677AbYAPENT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758677AbYAPENT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 23:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbYAPENL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 23:13:11 -0500
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:33049 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755641AbYAPENJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 23:13:09 -0500
Subject: 2.6.24-rc7-rt3
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Tue, 15 Jan 2008 23:12:53 -0500
Message-Id: <1200456773.318.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the 2.6.24-rc7-rt3 tree, which can be
downloaded from the location:

  http://rt.et.redhat.com/download/

Information on the RT patch can be found at:

  http://rt.wiki.kernel.org/index.php/Main_Page

Changes since 2.6.24-rc7-rt2

  - KVM updates (Thomas Gleixner)

  - more PPC32 compile fixes

  - Mips clean ups (Frank Rowand)

  - workqueue lock leak cleanup (Daniel Walker)

  - hacked fix for rt-migration (Mike Galbraith)


to build a 2.6.24-rc7-rt3 tree, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.23.tar.bz2
  http://www.kernel.org/pub/linux/kernel/v2.6/testing/patch-2.6.24-rc7.bz2
  http://rt.et.redhat.com/download/patch-2.6.24-rc7-rt3.bz2


And like always, my RT version of Matt Mackall's ketchup will get this
for you nicely:

  http://people.redhat.com/srostedt/rt/tools/ketchup-0.9.8-rt3


The broken out patches are also available.

-- Steve



