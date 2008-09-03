Return-Path: <linux-kernel-owner+w=401wt.eu-S1755386AbYICDQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386AbYICDQo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 23:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751760AbYICDQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 23:16:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:35142 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbYICDQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 23:16:34 -0400
Subject: 2.6.26.3-rt4
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Tue, 02 Sep 2008 23:16:31 -0400
Message-Id: <1220411791.22713.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the 2.6.26.3-rt4 tree, which can be
downloaded from the location:

  http://rt.et.redhat.com/download/

Information on the RT patch can be found at:

  http://rt.wiki.kernel.org/index.php/Main_Page

Changes since 2.6.26-rt3

  - updated to latest ftrace (Steven Rostedt)

  - SMP warning fix (Steven Rostedt and John Kacur)

  - Move crashkernel reservation (Bernhard Walle)


to build a 2.6.26.3-rt4 tree, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.26.tar.bz2
  http://kernel.org/pub/linux/kernel/v2.6/patch-2.6.26.3.bz2
  http://rt.et.redhat.com/download/patch-2.6.26.3-rt4.bz2



And like always, my RT version of Matt Mackall's ketchup will get this
for you nicely:

  http://people.redhat.com/srostedt/rt/tools/ketchup-0.9.8-rt3


The broken out patches are also available.


-- Steve


