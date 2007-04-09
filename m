Return-Path: <linux-kernel-owner+w=401wt.eu-S1751615AbXDIU67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615AbXDIU67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 16:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751635AbXDIU67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 16:58:59 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:57078 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750999AbXDIU66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 16:58:58 -0400
Date: Mon, 9 Apr 2007 16:53:47 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: gerg@uclinux.org, uclinux-dev@uclinux.org, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: m68knommu and vmlinux.lds.h RODATA
Message-ID: <20070409205347.GA32267@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 16:50:14 up 66 days, 10:57,  3 users,  load average: 1.56, 1.25, 1.13
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Is there any particular reason why m68knommu does not use the RODATA
linker script macro defined in asm-generic/vmlinux.lds.h ? It makes it
rather inconvenient to add new RO sections to the kernel.

Regards,

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
