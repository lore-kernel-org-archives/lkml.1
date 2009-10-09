Return-Path: <linux-kernel-owner+w=401wt.eu-S1753061AbZJIHp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061AbZJIHp1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 03:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752879AbZJIHp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 03:45:26 -0400
Received: from mga11.intel.com ([192.55.52.93]:2423 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503AbZJIHp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 03:45:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,530,1249282800"; 
   d="scan'208";a="501386470"
Subject: Re: [PATCH 6/6] mce-inject: use injected mce only during faked
 handler call
From: Huang Ying <ying.huang@intel.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4ACEE5E0.3050701@jp.fujitsu.com>
References: <1254100882.15717.1312.camel@yhuang-dev.sh.intel.com>
	 <4AC95F5A.4000708@jp.fujitsu.com>  <4AC96391.1060001@jp.fujitsu.com>
	 <1255072482.5228.157.camel@yhuang-dev.sh.intel.com>
	 <4ACEE5E0.3050701@jp.fujitsu.com>
Content-Type: text/plain
Date: Fri, 09 Oct 2009 15:44:46 +0800
Message-Id: <1255074286.5228.163.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-09 at 15:27 +0800, Hidetoshi Seto wrote: 
> Huang Ying wrote:
> > This is another example for you to use my idea, implement it in a
> > similar way and send it out as your own.
> 
> I used "Reported-by:" for this patch, having some intent to indicate
> that this patch uses an idea different from the original one, and that
> this patch aims at the problem certainly reported by you.

The point of the idea is to use two flags instead of one flag, not the
name of the flag or they are inside/outside of struct mce.

Best Regards,
Huang Ying


