Return-Path: <linux-kernel-owner+w=401wt.eu-S1754801AbZEOBpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbZEOBpl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 21:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753336AbZEOBpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 21:45:31 -0400
Received: from mga03.intel.com ([143.182.124.21]:34148 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753293AbZEOBpa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 21:45:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,197,1241420400"; 
   d="scan'208";a="143070838"
From: "Cihula, Joseph" <joseph.cihula@intel.com>
To: James Morris <jmorris@namei.org>, Theodore Tso <tytso@mit.edu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>,
       "Wei, Gang" <gang.wei@intel.com>, "Wang, Shane" <shane.wang@intel.com>,
       John Gilmore <gnu@toad.com>
Date: Thu, 14 May 2009 18:45:29 -0700
Subject: RE: [RFC v3][PATCH 2/2] intel_txt: Intel(R) TXT and tboot kernel
 support
Thread-Topic: [RFC v3][PATCH 2/2] intel_txt: Intel(R) TXT and tboot kernel
 support
Thread-Index: AcnU8rO81/QhJ4ZwRVGwjYWYnfSiiwAC7sxw
Message-ID: <4F65016F6CB04E49BFFA15D4F7B798D99B4752F3@orsmsx506.amr.corp.intel.com>
References: <4A03B9C3.9090607@intel.com> <20090512210154.GC23773@mit.edu>
 <alpine.LRH.2.00.0905151006020.5527@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.00.0905151006020.5527@tundra.namei.org>
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
> Sent: Thursday, May 14, 2009 5:18 PM
>
> On Tue, 12 May 2009, Theodore Tso wrote:
>
> > So we should expect a certain amount of controversy and people
> > lobbying to resist the acceptance of this patch.
>
> FWIW, here's my response to an earlier private enquiry from John on the
> topic:
>
>   I'd prefer discussion to be public, so I don't mind leaving more
>   detailed discussion to that.
>
>   There has been considerable discussion on the issue, following Linus'
>   statement (which I'm sure you're aware of):
>
>   http://marc.info/?l=linux-kernel&m=105115686114064&w=2
>
>   My position is similar -- people can decide for themselves whether they
>   want to use DRM technology.  I'm also confident that technical measures
>   taken to prevent real freedom will always be broken (when have they ever
>   not been?)
>
>   I also feel there may be genuinely useful applications of some of the
>   technology (e.g. sealing disk encryption keys in the TPM a la
>   BitLocker).
>
>
> I'm fairly neutral on the technology itself and feel that "market
> pressure" from users as well as local regulatory policy (e.g. anti-trust
> laws) should determine how the technology is used, rather than the views
> of a few kernel hackers.
>
>
> - James
> --
> James Morris
> <jmorris@namei.org>

For a balanced view on Trusted Computing, people should also read David Safford's (IBM) rebuttal whitepaper at: http://www.research.ibm.com/gsal/tcpa/tcpa_rebuttal.pdf.

As James points out, there has been a lot written, argued, and debated about Trusted Computing and I would encourage those who are concerned about it to read the discussions and then look at the documentation and presentations on Intel(R) Trusted Execution Technology (Intel(R) TXT).  Any technology can be used for good or bad, but Intel has tried to ensure that users have control of TXT.

I would also encourage those who are concerned about these patches to look at the Linux code and tboot code to satisfy themselves that it is providing exactly what we have claimed.

Joe
