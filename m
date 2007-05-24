Return-Path: <linux-kernel-owner+w=401wt.eu-S1754119AbXEXVQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbXEXVQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 17:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751027AbXEXVQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 17:16:46 -0400
Received: from mga03.intel.com ([143.182.124.21]:25910 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbXEXVQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 17:16:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,575,1170662400"; 
   d="scan'208";a="231816476"
Date: Thu, 24 May 2007 14:13:37 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Andi Kleen <ak@suse.de>
Cc: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Len Brown <len.brown@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Display Intel Dynamic Acceleration feature in /proc/cpuinfo
Message-ID: <20070524211337.GB3692@linux-os.sc.intel.com>
References: <20070523224637.GB15887@linux-os.sc.intel.com> <20070524135513.b6efacbf.akpm@linux-foundation.org> <20070524210103.GA5380@redhat.com> <200705242308.38360.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705242308.38360.ak@suse.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2007 at 11:08:38PM +0200, Andi Kleen wrote:
> 
> I think it's generally a good idea to push cpuinfo flags in earliest
> as possible; just make sure we actually use the final name (so that we don't get
> into a pni->sse3 mess again) 
>  

ida is official name as in the Software Developer's Manual now. So, should
not be a issue unless marketing folks change their mind in future :-)

Thanks,
Venki
