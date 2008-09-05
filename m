Return-Path: <linux-kernel-owner+w=401wt.eu-S1753047AbYIEEgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbYIEEgo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 00:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750835AbYIEEgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 00:36:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:64375 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbYIEEgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 00:36:33 -0400
Subject: 2.6.26.3-rt6
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Fri, 05 Sep 2008 00:36:30 -0400
Message-Id: <1220589390.22713.10.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the 2.6.26.3-rt6 tree, which can be
downloaded from the location:

  http://rt.et.redhat.com/download/

Information on the RT patch can be found at:

  http://rt.wiki.kernel.org/index.php/Main_Page

Changes since 2.6.26-rt5

  - rebased ftrace to latest (Steven Rostedt)

  - schedule RT task push/pull improvements (Gregory Haskins)

  - pm qos requirement updated patch (John Kacur)

  - PowerPC ftrace mcount undefined symbol fix (Steven Rostedt)

to build a 2.6.26.3-rt6 tree, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.26.tar.bz2
  http://kernel.org/pub/linux/kernel/v2.6/patch-2.6.26.3.bz2
  http://rt.et.redhat.com/download/patch-2.6.26.3-rt6.bz2



And like always, my RT version of Matt Mackall's ketchup will get this
for you nicely:

  http://people.redhat.com/srostedt/rt/tools/ketchup-0.9.8-rt3


The broken out patches are also available.


-- Steve


