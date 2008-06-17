Return-Path: <linux-kernel-owner+w=401wt.eu-S1754567AbYFQA5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbYFQA5m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 20:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751958AbYFQA5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 20:57:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:5499 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbYFQA5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 20:57:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,655,1204531200"; 
   d="scan'208";a="578651053"
Subject: Re: [PATCH 4/8] x86 boot: allow overlapping ebda and efi memmap
	memory ranges
From: "Huang, Ying" <ying.huang@intel.com>
To: Paul Jackson <pj@sgi.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, mingo@elte.hu, tglx@linutronix.de,
       yhlu.kernel@gmail.com, steiner@sgi.com, travis@sgi.com,
       linux-kernel@vger.kernel.org, andi@firstfloor.org,
       akpm@linux-foundation.org
In-Reply-To: <20080616130503.1a3a72dc.pj@sgi.com>
References: <20080616062945.14597.78009.sendpatchset@polaris-admin.engr.sgi.com>
	 <20080616063001.14597.96170.sendpatchset@polaris-admin.engr.sgi.com>
	 <1213600062.11185.13.camel@caritas-dev.intel.com>
	 <20080616032457.718f4d87.pj@sgi.com>
	 <1213606435.12968.14.camel@caritas-dev.intel.com>
	 <48568B56.7060307@zytor.com> <20080616113806.2ff4c1a4.pj@sgi.com>
	 <48569D62.9050107@zytor.com> <20080616123721.bb9195e6.pj@sgi.com>
	 <4856A6F9.3090605@zytor.com>  <20080616130503.1a3a72dc.pj@sgi.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 17 Jun 2008 09:00:14 +0800
Message-Id: <1213664414.17772.0.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-OriginalArrivalTime: 17 Jun 2008 00:57:14.0026 (UTC) FILETIME=[14B388A0:01C8D015]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-16 at 13:05 -0500, Paul Jackson wrote:
[...]
> Huang - would you agree to this safety reservation of the ebda area
> even on EFI enabled systems?

I am OK with this.

Best Regards,
Huang Ying

