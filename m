Return-Path: <linux-kernel-owner+w=401wt.eu-S1755986AbZKCHLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986AbZKCHLy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 02:11:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754907AbZKCHLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 02:11:53 -0500
Received: from mga11.intel.com ([192.55.52.93]:24181 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753606AbZKCHLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 02:11:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,672,1249282800"; 
   d="scan'208";a="510164249"
Subject: Re: [PATCH 11/14] cpumask: use modern cpumask style in
 arch/x86/kernel/cpu/mcheck/mce-inject.c
From: Huang Ying <ying.huang@intel.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "x86@kernel.org" <x86@kernel.org>, Andi Kleen <ak@linux.intel.com>
In-Reply-To: <200911031458.30987.rusty@rustcorp.com.au>
References: <200911031458.30987.rusty@rustcorp.com.au>
Content-Type: text/plain
Date: Tue, 03 Nov 2009 15:11:56 +0800
Message-Id: <1257232316.22519.32.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-03 at 12:28 +0800, Rusty Russell wrote: 
> Note that there's no freeing the cpu var, since this module has no
> unload function.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Cc: x86@kernel.org
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: Huang Ying <ying.huang@intel.com>

Acked-by: Huang Ying <ying.huang@intel.com>

Best Regards,
Huang Ying


