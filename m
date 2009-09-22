Return-Path: <linux-kernel-owner+w=401wt.eu-S1752654AbZIVWSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbZIVWSc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 18:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751992AbZIVWSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 18:18:31 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:60001 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbZIVWSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 18:18:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=x8Qm8tresvlFY/rEM/LSDm8cqjuIas7dPmZkcpGJeQZgbqopf2GVNDT8AjRGXrOv94
         61HaK1i6qVzyoJYTL1SpCcTcFJx6V+Wx3FUYrPva/zAQUMiTpuMPwKl6ytjsnwyPzkBL
         nmJMMNgbM/3UqjHnEjbO8zkilJGz8gQeCpGSc=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [GIT PULL] tracing fixes for -tip
Date: Wed, 23 Sep 2009 00:18:28 +0200
Message-Id: <1253657910-2536-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull these two fixlets that can be found at

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	tracing/urgent

Thanks,
Frederic.

---
The following changes since commit 79fe249c8368be35c9ca05982e80c68e959505e1:
  Li Zefan (1):
        tracing: Fix failure path in ftrace_regex_open()

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git ..BRANCH.NOT.VERIFIED..

Anton Blanchard (1):
      tracing/workqueue: Use %pf in workqueue trace events

Li Hong (1):
      tracing: Fix a comment and a trivial format issue in tracepoint.h

 include/linux/tracepoint.h       |    4 ++--
 include/trace/events/workqueue.h |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)
