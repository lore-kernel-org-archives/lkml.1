Return-Path: <linux-kernel-owner+w=401wt.eu-S933088AbZKXOfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933088AbZKXOfR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 09:35:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933079AbZKXOfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 09:35:14 -0500
Received: from mail-qy0-f192.google.com ([209.85.221.192]:34500 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932991AbZKXOfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 09:35:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=F+dHxEDDek0nn1ArgNaJexgMoDD4ipg+Z99bQ0JCdokeaKRiDFVnfTWFJ16A5PcHXD
         NTLMYFsj/omumCWyEspe9MvrD0CL0Y7SzPSTsQjmvfU2wwvOTACgHYc6+bYZ4jXudk2S
         W3pYvF06s+FhMi1O2lrVWjc2fMuOFQ/0yV8o0=
From: John Kacur <jkacur@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, acme@redhat.com,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH] perf-tools: Add perf.data to .gitignore
Date: Tue, 24 Nov 2009 15:35:00 +0100
Message-Id: <1259073301-11506-2-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1259073301-11506-1-git-send-email-jkacur@redhat.com>
References: <1259073301-11506-1-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 tools/perf/.gitignore |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/.gitignore b/tools/perf/.gitignore
index 0854f11..fe08660 100644
--- a/tools/perf/.gitignore
+++ b/tools/perf/.gitignore
@@ -12,6 +12,7 @@ perf*.1
 perf*.xml
 perf*.html
 common-cmds.h
+perf.data
 tags
 TAGS
 cscope*
-- 
1.6.0.6

