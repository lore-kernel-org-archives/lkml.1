Return-Path: <linux-kernel-owner+w=401wt.eu-S1757621AbZGRCpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757621AbZGRCpm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 22:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757303AbZGRCpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 22:45:40 -0400
Received: from mga14.intel.com ([143.182.124.37]:17905 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757232AbZGRCpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 22:45:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,224,1246863600"; 
   d="scan'208";a="166337238"
Date: Sat, 18 Jul 2009 10:45:10 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Izik Eidus <ieidus@redhat.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       "aarcange@redhat.com" <aarcange@redhat.com>,
       "chrisw@redhat.com" <chrisw@redhat.com>,
       "avi@redhat.com" <avi@redhat.com>, "riel@redhat.com" <riel@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH 06/10] ksm: identify PageKsm pages
Message-ID: <20090718024510.GB10524@localhost>
References: <1247851850-4298-1-git-send-email-ieidus@redhat.com> <1247851850-4298-2-git-send-email-ieidus@redhat.com> <1247851850-4298-3-git-send-email-ieidus@redhat.com> <1247851850-4298-4-git-send-email-ieidus@redhat.com> <1247851850-4298-5-git-send-email-ieidus@redhat.com> <1247851850-4298-6-git-send-email-ieidus@redhat.com> <1247851850-4298-7-git-send-email-ieidus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247851850-4298-7-git-send-email-ieidus@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 18, 2009 at 01:30:46AM +0800, Izik Eidus wrote:
> From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> 
> KSM will need to identify its kernel merged pages unambiguously,
> and /proc/kpageflags will probably like to do so too.

Thanks. I'll update the user space page-types tool after the patch
series is in -mm.

Thanks,
Fengguang
