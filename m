Return-Path: <linux-kernel-owner+w=401wt.eu-S1755369AbZCaIVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbZCaIVB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 04:21:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751021AbZCaIUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 04:20:43 -0400
Received: from mga14.intel.com ([143.182.124.37]:44165 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbZCaIUl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 04:20:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,451,1233561600"; 
   d="scan'208";a="126014952"
From: "Cihula, Joseph" <joseph.cihula@intel.com>
To: James Morris <jmorris@namei.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>,
       "Wei, Gang" <gang.wei@intel.com>, "Wang, Shane" <shane.wang@intel.com>
Date: Tue, 31 Mar 2009 01:20:37 -0700
Subject: RE: [RFC v2][PATCH 0b/1] intel_txt: Intel(R) Trusted Execution
 Technology support for Linux - Details
Thread-Topic: [RFC v2][PATCH 0b/1] intel_txt: Intel(R) Trusted Execution
 Technology support for Linux - Details
Thread-Index: Acmxzl3THu+xsCAlT2u7QiDWgmxMnwACmjfw
Message-ID: <4F65016F6CB04E49BFFA15D4F7B798D99469C2B0@orsmsx506.amr.corp.intel.com>
References: <49D1A6A5.8080501@intel.com>
 <alpine.LRH.2.00.0903311752260.13053@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.00.0903311752260.13053@tundra.namei.org>
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

> From: James Morris [mailto:jmorris@namei.org]
> Sent: Tuesday, March 31, 2009 12:00 AM
>
> On Mon, 30 Mar 2009, Joseph Cihula wrote:
>
> >   -  If tboot determines that the system does not support Intel TXT or is not
> >      configured correctly (e.g. the SINIT AC Module was incorrect), it will
> >      directly launch the kernel with no changes to any state.
>
> AC means "authenticated code", right?

Right.

> How readily can these be redistributed?  The license says:
>
> "... you may make a reasonable number of copies of the Software for
> internal use only, subject to these conditions:
> 1. You may not copy, modify, rent, sell, distribute, externally display,
>    externally perform or transfer any part of the Software except as provided
>    in this Agreement, and you agree to prevent unauthorized copying of the
>    Software.  "
>
> which seems to limit the ability of distributions to include the modules,
> in case they're redistributed.

We will be updating the license, shortly, to one that allows re-distribution.  We are in the process of validating new versions of all of the modules and will update the licenses when we update the ACMs.

Joe
