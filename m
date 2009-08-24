Return-Path: <linux-kernel-owner+w=401wt.eu-S1751956AbZHXIVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbZHXIVA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 04:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751081AbZHXIU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 04:20:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:42232 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829AbZHXIU6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 04:20:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,264,1249282800"; 
   d="scan'208";a="544151028"
From: "Wang, Shane" <shane.wang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <andi@firstfloor.org>,
       "Cihula, Joseph" <joseph.cihula@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>,
       "Wei, Gang" <gang.wei@intel.com>
Date: Mon, 24 Aug 2009 16:20:05 +0800
Subject: RE: [PATCH] intel_txt: fix the build errors of intel_txt patch on
 non-X86 platforms
Thread-Topic: [PATCH] intel_txt: fix the build errors of intel_txt patch on
 non-X86 platforms
Thread-Index: AcoihBpVxMaOWNEVRG+wL0/wgDA7vgCDyh/g
Message-ID: <037F493892196B458CD3E193E8EBAD4F01EC3ABB56@pdsmsx502.ccr.corp.intel.com>
References: <4A4ACA66.2000706@intel.com> <20090817154055.GA12985@elte.hu>
 <20090817155348.GA2254@elte.hu>
 <037F493892196B458CD3E193E8EBAD4F01EC3AB3B2@pdsmsx502.ccr.corp.intel.com>
 <20090820161038.GA29994@basil.fritz.box> <4A8E9B3C.5070604@intel.com>
 <20090821135050.GA30346@elte.hu> <4A8EBBF6.3020505@intel.com>
 <20090821161204.GB17731@elte.hu> <4A8ED800.30901@zytor.com>
In-Reply-To: <4A8ED800.30901@zytor.com>
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

>> 
>> If then these should be dummy inlines - but in any case, do you
>> expect tboot to be used by non-x86 too?
>> 
> 
> It would have to be IA64 ... I can't ask Tony since he's out, but I
> would assume it is x86-specific at this point.
> 
> 	-hpa

Yes, to my knowledge, it is x86 at this point. TXT-SX is the server extension also for ia32 only.

Shane

