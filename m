Return-Path: <linux-kernel-owner+w=401wt.eu-S1755779AbZJFA3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779AbZJFA3n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 20:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755280AbZJFA3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 20:29:43 -0400
Received: from mga14.intel.com ([143.182.124.37]:1759 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754966AbZJFA3m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 20:29:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,509,1249282800"; 
   d="scan'208";a="195424166"
From: "Kay, Allen M" <allen.m.kay@intel.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Chris Wright <chrisw@sous-sol.org>
CC: Chris Wright <chrisw@sous-sol.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "matthew@wil.cx" <matthew@wil.cx>
Date: Mon, 5 Oct 2009 17:29:03 -0700
Subject: RE: [PATCH ACS v3 1/1]
Thread-Topic: [PATCH ACS v3 1/1]
Thread-Index: AcpGGfwXi5dPIhBKRAC+ccPQ5wpCTwAAHmgA
Message-ID: <57C9024A16AD2D4C97DC78E552063EA3E3021D49@orsmsx505.amr.corp.intel.com>
References: <1253231193-5753-1-git-send-email-allen.m.kay@intel.com>
	<20090929000041.GB3958@sequoia.sous-sol.org>
	<57C9024A16AD2D4C97DC78E552063EA3E2EA3B70@orsmsx505.amr.corp.intel.com>
	<20090929184650.GF3958@sequoia.sous-sol.org>
	<57C9024A16AD2D4C97DC78E552063EA3E2F0411F@orsmsx505.amr.corp.intel.com>
	<20091001011721.GK3958@sequoia.sous-sol.org>
 <20091005171419.5464502d@jbarnes-g45>
In-Reply-To: <20091005171419.5464502d@jbarnes-g45>
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

Jesse,

I will send you a replacement patch since the size of the patch is not so big.

Allen

-----Original Message-----
From: Jesse Barnes [mailto:jbarnes@virtuousgeek.org] 
Sent: Monday, October 05, 2009 5:14 PM
To: Chris Wright
Cc: Kay, Allen M; Chris Wright; linux-kernel@vger.kernel.org; linux-pci@vger.kernel.org; matthew@wil.cx
Subject: Re: [PATCH ACS v3 1/1]

On Wed, 30 Sep 2009 18:17:21 -0700
Chris Wright <chrisw@sous-sol.org> wrote:

> * Kay, Allen M (allen.m.kay@intel.com) wrote:
> > On the other hand, can we say VT-d PT mode is mainly for KVM
> > virtualization use case?  If so, is it reasonable to say
> > performance of host P2P in this mode is not of highest priority?
> 
> Guess it depends on the workload.  Would be helpful to identify a use
> case that is p2p heavy (and then the impact of enabling ACS).
> 
> > If not, another option is to have a kernel boot parameter to
> > configure an kernel boot instance to be either host kernel
> > optimized or virtualization optimized.  I don't know whether this
> > is a reasonable or not ...
> 
> I was thinking that ACS could be enabled if an IOMMU is enabled.  Not
> a perfect fit, but seems reasonably close.

Allen, did you want to do these changes as an incremental patch on your
last one or just send me a replacement?  Either way is fine with me.

-- 
Jesse Barnes, Intel Open Source Technology Center
