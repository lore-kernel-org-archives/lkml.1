Return-Path: <linux-kernel-owner+w=401wt.eu-S1755793AbZFRVnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793AbZFRVnW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 17:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753172AbZFRVnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 17:43:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:34637 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753141AbZFRVnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 17:43:15 -0400
Date: Thu, 18 Jun 2009 21:42:51 GMT
From: tip-bot for Arnd Bergmann <arnd@arndb.de>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <cover.1245354003.git.arnd@arndb.de>
References: <cover.1245354003.git.arnd@arndb.de>
Subject: [tip:x86/asm-generic] x86: add copies of some headers to convert to asm-generic
Message-ID: <tip-4adc667593f83a18a8e54ce94f250fd166a272ac@git.kernel.org>
Git-Commit-ID: 4adc667593f83a18a8e54ce94f250fd166a272ac
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 18 Jun 2009 21:42:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4adc667593f83a18a8e54ce94f250fd166a272ac
Gitweb:     http://git.kernel.org/tip/4adc667593f83a18a8e54ce94f250fd166a272ac
Author:     Arnd Bergmann <arnd@arndb.de>
AuthorDate: Thu, 18 Jun 2009 21:48:16 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 18 Jun 2009 14:39:40 -0700

x86: add copies of some headers to convert to asm-generic

Just an intermediate step to make reviewing easier.
These files are identical copies of the existing headers.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
LKML-Reference: <cover.1245354003.git.arnd@arndb.de>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>


---
 arch/x86/include/asm/{mman.h => generic-mman.h}    |    0
 .../x86/include/asm/{module.h => generic-module.h} |    0
 .../asm/{scatterlist.h => generic-scatterlist.h}   |    0
 arch/x86/include/asm/{types.h => generic-types.h}  |    0
 .../include/asm/{ucontext.h => generic-ucontext.h} |    0
 5 files changed, 0 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/mman.h b/arch/x86/include/asm/generic-mman.h
similarity index 100%
copy from arch/x86/include/asm/mman.h
copy to arch/x86/include/asm/generic-mman.h
diff --git a/arch/x86/include/asm/module.h b/arch/x86/include/asm/generic-module.h
similarity index 100%
copy from arch/x86/include/asm/module.h
copy to arch/x86/include/asm/generic-module.h
diff --git a/arch/x86/include/asm/scatterlist.h b/arch/x86/include/asm/generic-scatterlist.h
similarity index 100%
copy from arch/x86/include/asm/scatterlist.h
copy to arch/x86/include/asm/generic-scatterlist.h
diff --git a/arch/x86/include/asm/types.h b/arch/x86/include/asm/generic-types.h
similarity index 100%
copy from arch/x86/include/asm/types.h
copy to arch/x86/include/asm/generic-types.h
diff --git a/arch/x86/include/asm/ucontext.h b/arch/x86/include/asm/generic-ucontext.h
similarity index 100%
copy from arch/x86/include/asm/ucontext.h
copy to arch/x86/include/asm/generic-ucontext.h
