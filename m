Return-Path: <linux-kernel-owner+w=401wt.eu-S1753896AbYKFVO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896AbYKFVO3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 16:14:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053AbYKFVON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 16:14:13 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:47666 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbYKFVOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 16:14:11 -0500
Message-Id: <20081106211307.944238362@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 06 Nov 2008 16:13:07 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Alexey Dobriyan <adobriyan@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
Subject: [PATCH 0/0] ftrace: fix hardirq.h for m68k
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo and Stephen,

The problem that Alexey pointed out should be fixed by this trivial patch.

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/devel


Steven Rostedt (1):
      ftrace: split out hardirq ftrace code into own header

