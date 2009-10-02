Return-Path: <linux-kernel-owner+w=401wt.eu-S1757337AbZJBRFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337AbZJBRFG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 13:05:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757147AbZJBRFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 13:05:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:49657 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756952AbZJBRFE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 13:05:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,495,1249282800"; 
   d="scan'208";a="454049023"
From: "Wang, Shane" <shane.wang@intel.com>
To: Pavel Machek <pavel@ucw.cz>
CC: Arjan van de Ven <arjan@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "Cihula, Joseph" <joseph.cihula@intel.com>
Date: Sat, 3 Oct 2009 01:02:52 +0800
Subject: RE: [GIT PULL] x86/txt for v2.6.32
Thread-Topic: [GIT PULL] x86/txt for v2.6.32
Thread-Index: AcpBmvovGzcIipIkSRSmfCqAYLlcJgB5Vc3g
Message-ID: <037F493892196B458CD3E193E8EBAD4F01ED9FE6E3@pdsmsx502.ccr.corp.intel.com>
References: <200909142051.n8EKpiOM017912@terminus.zytor.com>
 <200909262344.21257.rjw@sisk.pl> <20090928210252.GD1960@elf.ucw.cz>
 <200909282307.56190.rjw@sisk.pl> <4AC1267D.6020405@zytor.com>
 <20090928211745.GA2119@elf.ucw.cz> <4AC1AA61.8070408@intel.com>
 <20090929171318.GC14405@elf.ucw.cz> <20090929191951.18315e94@infradead.org>
 <037F493892196B458CD3E193E8EBAD4F01ED9FE3B1@pdsmsx502.ccr.corp.intel.com>
 <20090930065448.GB11652@elf.ucw.cz>
In-Reply-To: <20090930065448.GB11652@elf.ucw.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So I modify the RAM content so that BIOS does not think measured
> environment existed before suspend?
> 									Pavel

Hi Pavel, what do you mean on this question? 
When do you modify the RAM? before S3 sleep?

Thanks.
Shane