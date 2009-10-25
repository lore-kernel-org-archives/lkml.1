Return-Path: <linux-kernel-owner+w=401wt.eu-S1752835AbZJYI74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbZJYI74 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 04:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbZJYI7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 04:59:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:28783 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752762AbZJYI7z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 04:59:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,620,1249282800"; 
   d="scan'208";a="740177135"
From: "Han, Weidong" <weidong.han@intel.com>
To: "'Chris Wright'" <chrisw@sous-sol.org>
CC: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "'iommu@lists.linux-foundation.org'" 
	<iommu@lists.linux-foundation.org>,
       "'David Woodhouse'" <dwmw2@infradead.org>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Date: Sun, 25 Oct 2009 16:59:41 +0800
Subject: RE: [PATCH] intr-remap: allow disabling source id checking
Thread-Topic: [PATCH] intr-remap: allow disabling source id checking
Thread-Index: AcpUwCFwKnMGyahNTKCbcTJcjqXsqgAkQHNw
Message-ID: <715D42877B251141A38726ABF5CABF2C05509A76D0@pdsmsx503.ccr.corp.intel.com>
References: <20091024012606.GB14926@sequoia.sous-sol.org>
 <715D42877B251141A38726ABF5CABF2C05509A7677@pdsmsx503.ccr.corp.intel.com>
 <20091024153856.GD14926@sequoia.sous-sol.org>
In-Reply-To: <20091024153856.GD14926@sequoia.sous-sol.org>
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

Chris Wright wrote:
> * Han, Weidong (weidong.han@intel.com) wrote:
>> Hi Chris,
>> 
>> How about get rid of the 'nointremap' option? Therefore keep only
>> one option for interrupt remapping. 
> 
> I'd prefer that too.  I kept it becauase it's user visible, and has
> shipped in 2.6.31.
> 
> thanks,
> -chris

It's ok.

Acked-by: Weidong Han <weidong.han@intel.com>

Regards,
Weidong