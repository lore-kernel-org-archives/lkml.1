Return-Path: <linux-kernel-owner+w=401wt.eu-S1759888AbZDIEj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759888AbZDIEj2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 00:39:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759989AbZDIEiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 00:38:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:57123 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759855AbZDIEiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 00:38:21 -0400
Date: Thu, 9 Apr 2009 04:37:37 GMT
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jaswinder@kernel.org, tglx@linutronix.de, mingo@elte.hu,
       jaswinderrajput@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jaswinder@kernel.org, tglx@linutronix.de, jaswinderrajput@gmail.com,
       mingo@elte.hu
In-Reply-To: <1239211186.9037.2.camel@ht.satnam>
References: <1239211186.9037.2.camel@ht.satnam>
Subject: [tip:x86/urgent] x86: cpu_debug remove execute permission
Message-ID: <tip-f20ab9c38fb85b4dde8b4139788ab9e735a35279@git.kernel.org>
Git-Commit-ID: f20ab9c38fb85b4dde8b4139788ab9e735a35279
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 09 Apr 2009 04:37:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f20ab9c38fb85b4dde8b4139788ab9e735a35279
Gitweb:     http://git.kernel.org/tip/f20ab9c38fb85b4dde8b4139788ab9e735a35279
Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
AuthorDate: Wed, 8 Apr 2009 22:49:46 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 9 Apr 2009 06:34:02 +0200

x86: cpu_debug remove execute permission

It seems by mistake these files got execute permissions so removing it.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
LKML-Reference: <1239211186.9037.2.camel@ht.satnam>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 0 files changed, 0 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/cpu_debug.h b/arch/x86/include/asm/cpu_debug.h
old mode 100755
new mode 100644
diff --git a/arch/x86/kernel/cpu/cpu_debug.c b/arch/x86/kernel/cpu/cpu_debug.c
old mode 100755
new mode 100644
