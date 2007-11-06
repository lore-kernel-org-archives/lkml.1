Return-Path: <linux-kernel-owner+w=401wt.eu-S1757321AbXKFUnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321AbXKFUnn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 15:43:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754587AbXKFUmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 15:42:47 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:62007 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756181AbXKFUmp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 15:42:45 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAPRfMEdMROHU/2dsb2JhbACBWw
Date: Tue, 6 Nov 2007 15:42:42 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 0/4] Add ARCH_SUPPORTS_KPROBES (take 2)
Message-ID: <20071106204242.GA18743@Krystal>
References: <20071031010345.301342580@polymtl.ca> <20071106203931.06063bab@dhcp-255-175.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20071106203931.06063bab@dhcp-255-175.norway.atmel.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:32:48 up 3 days,  1:38,  4 users,  load average: 1.35, 0.95,
	0.92
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Haavard Skinnemoen (hskinnemoen@atmel.com) wrote:
> On Tue, 30 Oct 2007 21:03:45 -0400
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > take 2, using def_bool this time.
> 
> Currently, avr32 doesn't include kernel/Kconfig.instrumentation, but
> defines KPROBES in arch/avr32/Kconfig.debug instead. I want to bring
> avr32 in sync with everyone else, but that will obviously conflict with
> this patchset.
> 
> Are these patches about to get merged or should I just send my stuff
> upstream and ask you to rebase afterwards?
> 

I have not posted them to Andrew yet. I can do it right away, so you
could rebase on them.

Mathieu


> Håvard

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
