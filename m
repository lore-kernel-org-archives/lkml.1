Return-Path: <linux-kernel-owner+w=401wt.eu-S1755358AbYLJSEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358AbYLJSEl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 13:04:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754832AbYLJSE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 13:04:27 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:40475 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbYLJSE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 13:04:26 -0500
Subject: 2.6.24.7-rt24
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <srostedt@redhat.com>
Content-Type: text/plain
Date: Wed, 10 Dec 2008 13:04:24 -0500
Message-Id: <1228932264.974.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the 2.6.24.7-rt24 tree, which can be
downloaded from the location:

  http://rt.et.redhat.com/download/

Information on the RT patch can be found at:

  http://rt.wiki.kernel.org/index.php/Main_Page

Changes since 2.6.24.7-rt21 (yes we quietly released 22 and 23)

  - fix of owners in rwlocks (Steven Rosted)

  - fix rwlock boosting (Thomas Gleixner)

  - force rwlock into slow path (Thomas Gleixner)

  - fix missing get struct from previous patches (Thomas Gleixner)

to build a 2.6.24.7-rt24 tree, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.24.tar.bz2
  http://kernel.org/pub/linux/kernel/v2.6/patch-2.6.24.7.bz2
  http://rt.et.redhat.com/download/patch-2.6.24.7-rt24.bz2


And like always, my RT version of Matt Mackall's ketchup will get this
for you nicely:

  http://people.redhat.com/srostedt/rt/tools/ketchup-0.9.8-rt3


The broken out patches are also available.


Note: 2.6.26-rt needs these updates too. We are still working on the new
RT git tree, and will port these patches to 26 soon.

-- Steve



