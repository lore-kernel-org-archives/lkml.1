Return-Path: <linux-kernel-owner+w=401wt.eu-S1764613AbYESWoJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764613AbYESWoJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:44:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755507AbYESWnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:43:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:34729 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974AbYESWny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:43:54 -0400
Subject: 2.6.25.4-rt2
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Mon, 19 May 2008 18:43:52 -0400
Message-Id: <1211237032.14697.76.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the 2.6.25.4-rt2 tree, which can be
downloaded from the location:

  http://rt.et.redhat.com/download/

Information on the RT patch can be found at:

  http://rt.wiki.kernel.org/index.php/Main_Page

Changes since 2.6.25.4-rt1

  - lateral lock stealing (Gregory Haskins)

  - rtmutex rearrange logic (Gregory Haskins)

  - rtmutex remove double xchg (Steven Rostedt)

  - adaptive spinlocks (Gregory Haskins, Sven Deitrich,
                        Peter Morreale, and Steven Rostedt)

  - tsc fixage (Thomas Gleixner)

to build a 2.6.25.4-rt2 tree, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.25.tar.bz2
  http://kernel.org/pub/linux/kernel/v2.6/patch-2.6.25.4.bz2
  http://rt.et.redhat.com/download/patch-2.6.25.4-rt2.bz2



And like always, my RT version of Matt Mackall's ketchup will get this
for you nicely:

  http://people.redhat.com/srostedt/rt/tools/ketchup-0.9.8-rt3


The broken out patches are also available.



-- Steve

	

