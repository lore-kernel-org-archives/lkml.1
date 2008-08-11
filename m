Return-Path: <linux-kernel-owner+w=401wt.eu-S1753407AbYHKR5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbYHKR5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 13:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751177AbYHKR5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 13:57:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:28541 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbYHKR5H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 13:57:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,189,1217833200"; 
   d="scan'208";a="369723286"
From: "Luck, Tony" <tony.luck@intel.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Joerg Roedel <joerg.roedel@amd.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mingo@redhat.com" <mingo@redhat.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Date: Mon, 11 Aug 2008 10:55:22 -0700
Subject: RE: [PATCH 0/3] make swiotlb prototypes generic
Thread-Topic: [PATCH 0/3] make swiotlb prototypes generic
Thread-Index: Acj72hUyJ2pPJnTZQLawMSohyVi6GwAASmLw
Message-ID: <57C9024A16AD2D4C97DC78E552063EA3083D401F@orsmsx505.amr.corp.intel.com>
References: <1218114409-20806-1-git-send-email-joerg.roedel@amd.com>
 <57C9024A16AD2D4C97DC78E552063EA3083841F6@orsmsx505.amr.corp.intel.com>
 <20080811174349.GP4524@elte.hu>
In-Reply-To: <20080811174349.GP4524@elte.hu>
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

> > Boot tested on ia64 (using generic_defconfig, tiger_defconfig and
> > zx1_defconfig).
>
> given that this touches both x86 and ia64, i suspect queueing it in -mm
> (as it is already) and merging it upstream from there would be the best
> approach?

That sounds fine to me.

-Tony
