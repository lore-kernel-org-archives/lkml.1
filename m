Return-Path: <linux-kernel-owner+w=401wt.eu-S1758468AbYAYWRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758468AbYAYWRr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 17:17:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754140AbYAYWRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 17:17:35 -0500
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:55828 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754914AbYAYWRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 17:17:33 -0500
Subject: 2.6.24-rt1
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Fri, 25 Jan 2008 17:17:13 -0500
Message-Id: <1201299433.318.21.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the 2.6.24-rt1 tree, which can be
downloaded from the location:

  http://rt.et.redhat.com/download/

Information on the RT patch can be found at:

  http://rt.wiki.kernel.org/index.php/Main_Page

Changes since 2.6.24-rc8-rt1

  - ported to 2.6.24


to build a 2.6.24-rt1 tree, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.24.tar.bz2
  http://rt.et.redhat.com/download/patch-2.6.24-rt1.bz2


And like always, my RT version of Matt Mackall's ketchup will get this
for you nicely:

  http://people.redhat.com/srostedt/rt/tools/ketchup-0.9.8-rt3


The broken out patches are also available.


*** NOTICE ***

This still has the old version of the latency tracer. I'll try to
release a -rt2 soon that has the new version. This way we can see what
kind of regressions the new version might give.

-- Steve



