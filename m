Return-Path: <linux-kernel-owner+w=401wt.eu-S1759359AbXK1Oaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759359AbXK1Oaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 09:30:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755759AbXK1Oa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 09:30:27 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:43520 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755673AbXK1Oa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 09:30:26 -0500
Subject: 2.6.23.9-rt12
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>
Content-Type: text/plain
Date: Wed, 28 Nov 2007 09:29:44 -0500
Message-Id: <1196260184.4778.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the 2.6.23.9-rt12 tree, which can be
downloaded from the location:

 http://www.kernel.org/pub/linux/kernel/projects/rt/

Changes since 2.6.23.1-rt11

  - Ported to 2.6.23.9

  - Backported the RT balance code from our submissions to upstream

  - Now missing Gregory's CPU Prio patch (those that are interested
                in testing that, should contact Gregory (email above)
                and come back with numbers to convince us that this
                is worth it).

to build a 2.6.23.9-rt12 tree, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.23.9.tar.bz2 
  http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.23.9-rt12.bz2

And like always, my RT version of Matt Mackall's ketchup will get this
for you nicely:

  http://people.redhat.com/srostedt/rt/tools/ketchup-0.9.8-rt2

  Note: the "-rt2".  Michal Schmidt help point out and fix the fact
    that "ketchup -s 2.6-rt" and "ketchup 2.6-rt" were broken.
    I never used that feature, but now I will.

The broken out patches are also available.

-- Steve

