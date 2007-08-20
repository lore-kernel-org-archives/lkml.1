Return-Path: <linux-kernel-owner+w=401wt.eu-S1757987AbXHTUha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987AbXHTUha (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 16:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762404AbXHTU3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 16:29:36 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:38850 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1764849AbXHTU3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 16:29:30 -0400
Date: Mon, 20 Aug 2007 16:29:28 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/23] cmpxchg_local and cmpxchg64_local implementation
Message-ID: <20070820202927.GA20936@Krystal>
References: <20070820201519.512791382@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070820201519.512791382@polymtl.ca>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:28:28 up 21 days, 20:47,  3 users,  load average: 1.59, 1.45, 0.96
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> Hi Andrew,
> 
> Changelog from the last post for this patchset:
> 
> - explained more thoroughly design choices in
>   i386-cmpxchg64-80386-80486-fallback patch header.
> - m32r compilation fix.
> - ia64 coding style fix.
> 

Applies to 2.6.23-rc2-mm2, in the following order:

i386-cmpxchg64-80386-80486-fallback.patch
#
add-cmpxchg-local-to-generic-for-up.patch
add-cmpxchg-local-to-arm.patch
add-cmpxchg-local-to-avr32.patch
add-cmpxchg-local-to-blackfin.patch
add-cmpxchg-local-to-cris.patch
add-cmpxchg-local-to-frv.patch
add-cmpxchg-local-to-h8300.patch
add-cmpxchg-local-to-ia64.patch
add-cmpxchg-local-to-m32r.patch
fix-m32r-__xchg.patch
local_t_m32r_optimized.patch
add-cmpxchg-local-to-m68k.patch
add-cmpxchg-local-to-m68knommu.patch
add-cmpxchg-local-to-parisc.patch
add-cmpxchg-local-to-ppc.patch
add-cmpxchg-local-to-s390.patch
add-cmpxchg-local-to-sh.patch
add-cmpxchg-local-to-sh64.patch
add-cmpxchg-local-to-sparc.patch
add-cmpxchg-local-to-sparc64.patch
add-cmpxchg-local-to-v850.patch
add-cmpxchg-local-to-xtensa.patch

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
