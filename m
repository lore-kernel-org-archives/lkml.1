Return-Path: <linux-kernel-owner+w=401wt.eu-S1754256AbZKJLu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256AbZKJLu6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 06:50:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbZKJLu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 06:50:57 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:61589 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbZKJLu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 06:50:56 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Subject: [PATCH 0/3] perf bench: Clean and add document for perf-bench
Date: Tue, 10 Nov 2009 20:50:52 +0900
Message-Id: <1257853855-28934-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series cleans bench/bench.h for readability and
adds new document describing perf-bench.

Hitoshi Mitake (3):
  perf bench: Clean bench/bench.h
  perf bench: Add new document of perf-bench
  perf bench: Modify command-list.txt for the entry of perf-bench

 tools/perf/Documentation/perf-bench.txt |  120 +++++++++++++++++++++++++++++++
 tools/perf/bench/bench.h                |   16 ++---
 tools/perf/command-list.txt             |    1 +
 3 files changed, 128 insertions(+), 9 deletions(-)
 create mode 100644 tools/perf/Documentation/perf-bench.txt

