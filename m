Return-Path: <linux-kernel-owner+w=401wt.eu-S1758013AbZJBSNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013AbZJBSNW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 14:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757708AbZJBSNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 14:13:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:17030 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757482AbZJBSNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 14:13:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,495,1249282800"; 
   d="scan'208";a="499323938"
Subject: Re: [patch 1/4] dmar: support for parsing Remapping Hardware
 Static Affinity structure
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "Brown, Len" <len.brown@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1254461981.3218.1219.camel@macbook.infradead.org>
References: <20091001230743.949931468@sbs-t61.sc.intel.com>
	 <1254461981.3218.1219.camel@macbook.infradead.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 02 Oct 2009 11:12:40 -0700
Message-Id: <1254507160.2661.6.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-01 at 22:39 -0700, David Woodhouse wrote:
> On Thu, 2009-10-01 at 16:06 -0700, Suresh Siddha wrote:
> > Add support for parsing Remapping Hardware Static Affinity (RHSA) structure.
> > This enables identifying the association between remapping hardware units and
> > the corresponding proximity domain. This enables to allocate transalation
> > structures closer to the remapping hardware unit.
> 
> That's not going to apply on top of commit 17b6097753e, is it?

Oops, didn't notice Roland's patch. Just posted the new set on top of
your tree.

thanks,
suresh

