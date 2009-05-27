Return-Path: <linux-kernel-owner+w=401wt.eu-S1760357AbZE0Iqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760357AbZE0Iqu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 04:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757912AbZE0Iql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 04:46:41 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47265 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758907AbZE0Iqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 04:46:40 -0400
Date: Wed, 27 May 2009 10:53:16 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "hpa@zytor.com" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 03/31] x86: MCE: Fix EIPV behaviour with !PCC
Message-ID: <20090527085316.GW846@one.firstfloor.org>
References: <1243382073-29338-1-git-send-email-andi@firstfloor.org> <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com> <c1d7bf910168f07efb50d98f901f41e289a87f1f.1243381848.git.ak@linux.intel.com> <6c6d1f8bbbd2312884dca5a5c75aa5f5a87dae4b.1243381848.git.ak@linux.intel.com> <4A1CC1E0.2030300@jp.fujitsu.com> <20090527073809.GU846@one.firstfloor.org> <1243409905.8361.29.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243409905.8361.29.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 03:38:25PM +0800, Huang Ying wrote:
> On Wed, 2009-05-27 at 15:38 +0800, Andi Kleen wrote:
> > > We never reach there with tolerant == 0.
> > 
> > Fair point. Ying do you remember which test case that fixed?
> 
> I think I fixed a "bug" that does not exist. So I think maybe we should

Or maybe not anymore.

> drop this patch. Sorry about that.

Okay. I dropped it. Thanks everyone.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
