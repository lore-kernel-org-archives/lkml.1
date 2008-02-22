Return-Path: <linux-kernel-owner+w=401wt.eu-S935859AbYBVA3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935859AbYBVA3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 19:29:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935518AbYBVA3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 19:29:00 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:59627 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935490AbYBVA2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 19:28:52 -0500
Subject: 2.6.24.2-rt2
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Thu, 21 Feb 2008 19:24:09 -0500
Message-Id: <1203639849.7551.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the 2.6.24.2-rt2 tree, which can be
downloaded from the location:

  http://rt.et.redhat.com/download/

Information on the RT patch can be found at:

  http://rt.wiki.kernel.org/index.php/Main_Page

Changes since 2.6.24-rt1

  - ported to 2.6.24.2

  - *** New ftrace utility ***
      The old latency_tracer has now been replaced with the cleaned up
      version that is being prepared for mainline.

  - compiler warning fix (Shi Weihua)


to build a 2.6.24.2-rt2 tree, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.24.tar.bz2
  http://kernel.org/pub/linux/kernel/v2.6/patch-2.6.24.2.bz2
  http://rt.et.redhat.com/download/patch-2.6.24.2-rt2.bz2


And like always, my RT version of Matt Mackall's ketchup will get this
for you nicely:

  http://people.redhat.com/srostedt/rt/tools/ketchup-0.9.8-rt3


The broken out patches are also available.



-- Steve



