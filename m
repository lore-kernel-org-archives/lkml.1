Return-Path: <linux-kernel-owner+w=401wt.eu-S1753091AbYIFFkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091AbYIFFkl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 01:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbYIFFkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 01:40:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:48414 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbYIFFkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 01:40:32 -0400
Subject: 2.6.26.3-rt7
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Sat, 06 Sep 2008 01:40:30 -0400
Message-Id: <1220679630.22713.12.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the 2.6.26.3-rt7 tree, which can be
downloaded from the location:

  http://rt.et.redhat.com/download/

Information on the RT patch can be found at:

  http://rt.wiki.kernel.org/index.php/Main_Page

Changes since 2.6.26-rt6

  - PPC ftrace fixes (Steven Rostedt)

  - PPC revert a reverted patch reverted again (Chirag Jog)

to build a 2.6.26.3-rt7 tree, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.26.tar.bz2
  http://kernel.org/pub/linux/kernel/v2.6/patch-2.6.26.3.bz2
  http://rt.et.redhat.com/download/patch-2.6.26.3-rt7.bz2



And like always, my RT version of Matt Mackall's ketchup will get this
for you nicely:

  http://people.redhat.com/srostedt/rt/tools/ketchup-0.9.8-rt3


The broken out patches are also available.


-- Steve


