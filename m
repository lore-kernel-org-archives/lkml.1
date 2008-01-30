Return-Path: <linux-kernel-owner+w=401wt.eu-S1760398AbYA3RQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760398AbYA3RQW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 12:16:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753719AbYA3RQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 12:16:09 -0500
Received: from mga01.intel.com ([192.55.52.88]:55359 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710AbYA3RQH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 12:16:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,278,1199692800"; 
   d="scan'208";a="510588130"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: x86/non-x86: percpu, node ids, apic ids x86.git fixup
Date: Wed, 30 Jan 2008 09:13:25 -0800
Message-ID: <1FE6DD409037234FAB833C420AA843EC757C72@orsmsx424.amr.corp.intel.com>
In-Reply-To: <20080130161036.GA12293@elte.hu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: x86/non-x86: percpu, node ids, apic ids x86.git fixup
Thread-Index: AchjWy82XxGcV+9xRNeLoOJjxguJ+AACAqhA
References: <200801301414.m0UEEgCC006371@hera.kernel.org> <Pine.LNX.4.64.0801301622460.11859@vixen.sonytel.be> <47A09F8A.3000309@sgi.com> <20080130161036.GA12293@elte.hu>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Mike Travis" <travis@sgi.com>
Cc: "Geert Uytterhoeven" <Geert.Uytterhoeven@sonycom.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Linux Kernel Development" <linux-kernel@vger.kernel.org>,
       "Linux/PPC Development" <linuxppc-dev@ozlabs.org>,
       <linux-ia64@vger.kernel.org>, <sparclinux@vger.kernel.org>
X-OriginalArrivalTime: 30 Jan 2008 17:13:28.0956 (UTC) FILETIME=[6EA94BC0:01C86363]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > This broke powerpc (and presumably ia64 and sparc64) in current 
> > > linux-2.6.git:
> > 
> > I'm generating a "fixup patch" right now...
>
> thanks! Sorry about that: we cross-built on ARM but not on SMP non-x86 
> platforms so this dependency/breakage went unnoticed.

Yes ... all ia64 builds (UP and SMP) are broken at the moment. Please
Cc: me with the fixup patch.

Thanks

-Tony
