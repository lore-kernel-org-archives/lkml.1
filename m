Return-Path: <linux-kernel-owner+w=401wt.eu-S932319AbXKPCXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319AbXKPCXi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 21:23:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754044AbXKPCXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 21:23:30 -0500
Received: from tomts22-srv.bellnexxia.net ([209.226.175.184]:59823 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750956AbXKPCX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 21:23:29 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAIeOPEdMROHU/2dsb2JhbACBXw
Date: Thu, 15 Nov 2007 21:23:19 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch 2/4] Add ARCH_SUPPORTS_OPROFILE
Message-ID: <20071116022319.GD16953@Krystal>
References: <20071116015925.175012068@polymtl.ca> <20071116020027.207316215@polymtl.ca> <20071115180830.106d594c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20071115180830.106d594c.akpm@linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 21:22:59 up 12 days,  7:28,  8 users,  load average: 0.49, 0.48,
	0.54
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On Thu, 15 Nov 2007 20:59:27 -0500 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> >  arch/x86/Kconfig.i386          |    1 +
> >  arch/x86/Kconfig.x86_64        |    1 +
> 
> these no longer exist.

Ok, should I prepare a fix or is it duplicated work ?

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
