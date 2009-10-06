Return-Path: <linux-kernel-owner+w=401wt.eu-S932403AbZJFMSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403AbZJFMSr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 08:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932290AbZJFMSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 08:18:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:34798 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932228AbZJFMSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 08:18:45 -0400
Date: Tue, 6 Oct 2009 12:17:41 GMT
From: tip-bot for Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel@vger.kernel.org, cebbert@redhat.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, cebbert@redhat.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <200910061138.n96BcqkJ004709@int-mx03.intmail.prod.int.phx2.redhat.com>
References: <200910061138.n96BcqkJ004709@int-mx03.intmail.prod.int.phx2.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf_events: Make ABI definitions available to userspace
Message-ID: <tip-e13dbd7d75d1ecc315c6e3071b3c4e8fba4f6bec@git.kernel.org>
Git-Commit-ID: e13dbd7d75d1ecc315c6e3071b3c4e8fba4f6bec
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 06 Oct 2009 12:17:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e13dbd7d75d1ecc315c6e3071b3c4e8fba4f6bec
Gitweb:     http://git.kernel.org/tip/e13dbd7d75d1ecc315c6e3071b3c4e8fba4f6bec
Author:     Chuck Ebbert <cebbert@redhat.com>
AuthorDate: Tue, 6 Oct 2009 07:38:51 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Oct 2009 13:44:03 +0200

perf_events: Make ABI definitions available to userspace

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
LKML-Reference: <200910061138.n96BcqkJ004709@int-mx03.intmail.prod.int.phx2.redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/Kbuild |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index cff4a10..3f384d4 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -126,6 +126,7 @@ header-y += nfs_mount.h
 header-y += nl80211.h
 header-y += param.h
 header-y += pci_regs.h
+header-y += perf_event.h
 header-y += pfkeyv2.h
 header-y += pg.h
 header-y += phantom.h
