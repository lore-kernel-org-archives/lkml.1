Return-Path: <linux-kernel-owner+w=401wt.eu-S1751352AbZDAKNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352AbZDAKNm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 06:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754261AbZDAKNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 06:13:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:39910 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753410AbZDAKNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 06:13:15 -0400
Date: Wed, 1 Apr 2009 10:12:38 GMT
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       arjan@linux.intel.com, srostedt@redhat.com, tglx@linutronix.de,
       laijs@cn.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, srostedt@redhat.com, tglx@linutronix.de,
       laijs@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <49D06B9C.3070209@cn.fujitsu.com>
References: <49D06B9C.3070209@cn.fujitsu.com>
Subject: [tip:tracing/urgent] tracing: move scripts/trace/power.pl to scripts/tracing/power.pl
Message-ID: <tip-4fafd5b03875612a24a5b17dac0c63217a65de42@git.kernel.org>
Git-Commit-ID: 4fafd5b03875612a24a5b17dac0c63217a65de42
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 10:12:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4fafd5b03875612a24a5b17dac0c63217a65de42
Gitweb:     http://git.kernel.org/tip/4fafd5b03875612a24a5b17dac0c63217a65de42
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Mon, 30 Mar 2009 14:50:04 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 1 Apr 2009 11:30:35 +0200

tracing: move scripts/trace/power.pl to scripts/tracing/power.pl

Impact: Cleanup

We use scripts/tracing/ to contain tracing scripts.
Use one directory only instead of two.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Steven Rostedt <srostedt@redhat.com>
LKML-Reference: <49D06B9C.3070209@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 scripts/{trace => tracing}/power.pl |    0
 1 files changed, 0 insertions(+), 0 deletions(-)

diff --git a/scripts/trace/power.pl b/scripts/tracing/power.pl
similarity index 100%
rename from scripts/trace/power.pl
rename to scripts/tracing/power.pl
