Return-Path: <linux-kernel-owner+w=401wt.eu-S1763108AbZE0Hno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763108AbZE0Hno (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762625AbZE0Hi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:38:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:23880 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763894AbZE0HiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:38:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,258,1241420400"; 
   d="scan'208";a="415982566"
Subject: Re: [PATCH 03/31] x86: MCE: Fix EIPV behaviour with !PCC
From: Huang Ying <ying.huang@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "hpa@zytor.com" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
       Andi Kleen <ak@linux.intel.com>
In-Reply-To: <20090527073809.GU846@one.firstfloor.org>
References: <1243382073-29338-1-git-send-email-andi@firstfloor.org>
	 <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
	 <c1d7bf910168f07efb50d98f901f41e289a87f1f.1243381848.git.ak@linux.intel.com>
	 <6c6d1f8bbbd2312884dca5a5c75aa5f5a87dae4b.1243381848.git.ak@linux.intel.com>
	 <4A1CC1E0.2030300@jp.fujitsu.com> <20090527073809.GU846@one.firstfloor.org>
Content-Type: text/plain
Date: Wed, 27 May 2009 15:38:25 +0800
Message-Id: <1243409905.8361.29.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-27 at 15:38 +0800, Andi Kleen wrote:
> > We never reach there with tolerant == 0.
> 
> Fair point. Ying do you remember which test case that fixed?

I think I fixed a "bug" that does not exist. So I think maybe we should
drop this patch. Sorry about that.

Best Regards,
Huang Ying

