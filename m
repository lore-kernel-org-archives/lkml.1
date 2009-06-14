Return-Path: <linux-kernel-owner+w=401wt.eu-S1758809AbZFNNz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758809AbZFNNz0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 09:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753263AbZFNNzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 09:55:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:44609 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426AbZFNNzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 09:55:16 -0400
Date: Sun, 14 Jun 2009 13:54:36 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf report: Print out raw events in hexa
Message-ID: <tip-8465b05046652cfde3d47692cab2e8ba962f140f@git.kernel.org>
Git-Commit-ID: 8465b05046652cfde3d47692cab2e8ba962f140f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 14 Jun 2009 13:54:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8465b05046652cfde3d47692cab2e8ba962f140f
Gitweb:     http://git.kernel.org/tip/8465b05046652cfde3d47692cab2e8ba962f140f
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sun, 14 Jun 2009 14:44:07 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 14 Jun 2009 14:45:12 +0200

perf report: Print out raw events in hexa

Print out events in hexa dump format, when -D is specified:

0x4868 [0x48]: event: 1
