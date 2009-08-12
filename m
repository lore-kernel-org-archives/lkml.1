Return-Path: <linux-kernel-owner+w=401wt.eu-S1752688AbZHLWhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbZHLWhb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 18:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752579AbZHLWha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 18:37:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:13856 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752578AbZHLWha convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 18:37:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,370,1246863600"; 
   d="scan'208";a="716297210"
From: "Wang, Shane" <shane.wang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, "Cihula, Joseph" <joseph.cihula@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>,
       "Wei, Gang" <gang.wei@intel.com>
Date: Thu, 13 Aug 2009 06:37:25 +0800
Subject: RE: [RFC v6][PATCH 0b/4] intel_txt: Intel(R) Trusted Execution
	Technology support for Linux - Details
Thread-Topic: [RFC v6][PATCH 0b/4] intel_txt: Intel(R) Trusted Execution
	Technology support for Linux - Details
Thread-Index: Acobgnhevh8fEJ69RNi9dOZ8RiAvKwAGu97Q
Message-ID: <037F493892196B458CD3E193E8EBAD4F01EAB64206@pdsmsx502.ccr.corp.intel.com>
References: <20090812182013.GJ28848@basil.fritz.box>
In-Reply-To: <20090812182013.GJ28848@basil.fritz.box>
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

H. Peter Anvin wrote:
> Right, that was the point.
> 
> Andi Kleen <andi@firstfloor.org> wrote:
> 
>>> The question is: if the user doesn't want S3, do they still need to
>>> enable S3 in order to be able to use TXT?  Otherwise, this code
>>> needs to be properly conditionalized.
>> 
>> I doubt that's the case. Ifdef is likely the right answer.
>> 
>> -Andi
>> 
>> --
>> ak@linux.intel.com -- Speaking for myself only.

OK, I agree.

Shane