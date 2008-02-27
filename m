Return-Path: <linux-kernel-owner+w=401wt.eu-S1754770AbYB0FIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbYB0FIl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 00:08:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750916AbYB0FIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 00:08:32 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:36010 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbYB0FIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 00:08:31 -0500
Subject: 2.6.24.3-rt3
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Wed, 27 Feb 2008 00:08:12 -0500
Message-Id: <1204088892.14759.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the 2.6.24.3-rt3 tree, which can be
downloaded from the location:

  http://rt.et.redhat.com/download/

Information on the RT patch can be found at:

  http://rt.wiki.kernel.org/index.php/Main_Page

Changes since 2.6.24.2-rt2

  - ported to 2.6.24.3

  - updates to ftrace (Ingo Molnar and Steven Rostedt)

  - root domain kfree fix (Gregory Haskins)

  - event trace compile fix (Clark Williams)


to build a 2.6.24.3-rt3 tree, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.24.tar.bz2
  http://kernel.org/pub/linux/kernel/v2.6/patch-2.6.24.3.bz2
  http://rt.et.redhat.com/download/patch-2.6.24.3-rt3.bz2


And like always, my RT version of Matt Mackall's ketchup will get this
for you nicely:

  http://people.redhat.com/srostedt/rt/tools/ketchup-0.9.8-rt3


The broken out patches are also available.



-- Steve

	

