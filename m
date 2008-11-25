Return-Path: <linux-kernel-owner+w=401wt.eu-S1752797AbYKYOV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbYKYOV7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 09:21:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750947AbYKYOVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 09:21:35 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:37232 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbYKYOVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 09:21:33 -0500
Message-Id: <20081125142041.038383632@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 25 Nov 2008 09:20:41 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Uros Bizjak <ubizjak@gmail.com>
Subject: [PATCH 0/1] Update for constraint fix
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo and Stephen,

Please use this patch instead. Uros Bizjak suggested using 'q' over 'Q'.

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: urgent


Steven Rostedt (1):
      use limited register constraint for setnz

----
 arch/x86/boot/tty.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
