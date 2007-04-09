Return-Path: <linux-kernel-owner+w=401wt.eu-S1752879AbXDIVEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879AbXDIVEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbXDIVDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:03:54 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:62826 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752881AbXDIVDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:03:39 -0400
Date: Mon, 9 Apr 2007 17:03:36 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: uclinux-v850@lsi.nec.co.jp, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: V850 and asm-generic/vmlinux.lds.h
Message-ID: <20070409210336.GA32759@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 17:01:29 up 66 days, 11:08,  3 users,  load average: 1.19, 1.11, 1.10
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am wondering if there is a good reason why the V850 architecture does
not use asm-generic/vmlinux.lds.h RODATA linker macro ? It would make
addition of new RODATA sections much easier.


Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
