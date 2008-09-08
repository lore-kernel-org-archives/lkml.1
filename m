Return-Path: <linux-kernel-owner+w=401wt.eu-S1754422AbYIHQrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbYIHQrb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 12:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbYIHQrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 12:47:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:58029 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597AbYIHQrE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 12:47:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,359,1217833200"; 
   d="scan'208";a="613982276"
From: "Luck, Tony" <tony.luck@intel.com>
To: Ingo Molnar <mingo@elte.hu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@redhat.com" <mingo@redhat.com>,
       the arch/x86 maintainers <x86@kernel.org>
Date: Mon, 8 Sep 2008 09:47:01 -0700
Subject: RE: [PATCH 0/3] minor cleanups for swiotlb
Thread-Topic: [PATCH 0/3] minor cleanups for swiotlb
Thread-Index: AckRupJaohAt7GJPSryNmfGXNtCKBQAF91hg
Message-ID: <57C9024A16AD2D4C97DC78E552063EA30A146F9D@orsmsx505.amr.corp.intel.com>
References: <1220867630-1995-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <20080908135510.GF11993@elte.hu>
In-Reply-To: <20080908135510.GF11993@elte.hu>
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

> applied to tip/x86/iommu, thanks!
>
> Tony, since ia64 makes use of CONFIG_SWIOTLB, do you have any objections
> to carrying these patches in tip/x86/iommu?

No objections from me.

-Tony
