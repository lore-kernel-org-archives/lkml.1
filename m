Return-Path: <linux-kernel-owner+w=401wt.eu-S932908AbXIFUNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932908AbXIFUNl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 16:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754831AbXIFUNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 16:13:31 -0400
Received: from tomts43.bellnexxia.net ([209.226.175.110]:57841 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754814AbXIFUNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 16:13:30 -0400
Date: Thu, 6 Sep 2007 16:13:26 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Combined patchset and series file for 2.6.23-rc4-mm1
Message-ID: <20070906201326.GA6300@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:08:43 up 38 days, 20:27,  4 users,  load average: 0.29, 0.56, 0.58
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Some people asdked me for a tarball easy to apply of my patches. I give
a link to it for those interested.

http://ltt.polymtl.ca/markers/markers-patches-for-2.6.23-rc4-mm1-06-09-2007.tar.bz2

Mathieu

It comes along with this series file:


kprobes-use-mutex-for-insn-pages.patch
kprobes-dont-use-kprobes-mutex-in-arch-code.patch
kprobes-declare-kprobes-mutex-static.patch
text-edit-lock-architecture-independent-code.patch
text-edit-lock-alternative-i386-and-x86_64.patch
text-edit-lock-kprobes-architecture-independent.patch
text-edit-lock-kprobes-i386.patch
text-edit-lock-kprobes-x86_64.patch
text-edit-lock-i386-standardize-debug-rodata.patch
text-edit-lock-x86_64-standardize-debug-rodata.patch
#
immediate-values-global-modules-list-and-mutex.patch
immediate-values-architecture-independent-code.patch
immediate-values-kconfig-embedded.patch
immediate-values-move-kprobes-i386-restore-interrupt-to-kdebug-h.patch
immediate-values-i386-optimization.patch
immediate-values-powerpc-optimization.patch
immediate-values-powerpc-optimization-fix.patch
immediate-values-documentation.patch
#
profiling-use-immediate-values.patch
#
seq_file_sorted.patch
module.c-sort-module-list.patch
#
linux-kernel-markers-architecture-independent-code.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-documentation.patch
linux-kernel-markers-documentation-fix.patch
linux-kernel-markers-port-blktrace-to-markers.patch
linux-kernel-markers-port-spu-to-markers.patch
#

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
