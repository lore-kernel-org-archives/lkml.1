Return-Path: <linux-kernel-owner+w=401wt.eu-S936722AbZAOW6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936722AbZAOW6l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 17:58:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935716AbZAOWoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:44:44 -0500
Received: from mga07.intel.com ([143.182.124.22]:15970 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932716AbZAOWol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:44:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,272,1231142400"; 
   d="scan'208";a="100502585"
Message-ID: <496FBC5D.9050503@linux.intel.com>
Date: Thu, 15 Jan 2009 23:44:45 +0100
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, andi@firstfloor.org, rth@twiddle.net,
       sfr@canb.auug.org.au, travis@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/8] compiler-gcc.h: add more comments to RELOC_HIDE
References: <200901100040.n0A0eruc013680@imap1.linux-foundation.org> <20090110122945.GA28033@elte.hu> <Pine.LNX.4.64.0901121128470.30369@quilx.com> <200901151227.27935.rusty@rustcorp.com.au> <alpine.LFD.2.00.0901141932290.6528@localhost.localdomain> <Pine.LNX.4.64.0901151300150.26467@quilx.com>
In-Reply-To: <Pine.LNX.4.64.0901151300150.26467@quilx.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:

> 
> From the include/compiler*.h files it looks as if we are supporting 3
> classes of compilers. Of those only gcc has this sickness.

The other compilers are essentially un (or very little-)tested. There
are undoubtedly some problems there that just noone hit due to lack
of testing.

-andi

