Return-Path: <linux-kernel-owner+w=401wt.eu-S1754501AbYKFVUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbYKFVUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 16:20:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754198AbYKFVUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 16:20:44 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:34116 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbYKFVUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 16:20:43 -0500
Message-Id: <20081106211949.320119144@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 06 Nov 2008 16:19:49 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Alexey Dobriyan <adobriyan@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
Subject: [PATCH 0/1] ftrace: fix hardirq.h for m68k
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[
  Lets try this again. This time in the patch directory.
]


Ingo and Stephen,

The problem that Alexey pointed out should be fixed by this trivial patch.

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/devel


Steven Rostedt (1):
      ftrace: split out hardirq ftrace code into own header

