Return-Path: <linux-kernel-owner+w=401wt.eu-S1751203AbZISRRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751203AbZISRRm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 13:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750846AbZISRRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 13:17:42 -0400
Received: from mga07.intel.com ([143.182.124.22]:40669 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750828AbZISRRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 13:17:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,416,1249282800"; 
   d="scan'208";a="189477681"
Date: Sat, 19 Sep 2009 20:55:45 -0400
From: "Youquan,Song" <youquan.song@linux.intel.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: "Youquan,Song" <youquan.song@linux.intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Song, Youquan" <youquan.song@intel.com>,
       "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] IR: Disallow interrupt remapping if not all ioapic under interrupt remapping
Message-ID: <20090920005545.GD21419@youquan-linux.bj.intel.com>
References: <20090907145807.GA30942@youquan-linux.bj.intel.com> <1252532575.2767.32.camel@sbs-t61.sc.intel.com> <20090920003737.GB21419@youquan-linux.bj.intel.com> <1253380022.6317.16.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253380022.6317.16.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 19, 2009 at 10:07:01AM -0700, David Woodhouse wrote:
> On Sat, 2009-09-19 at 20:37 -0400, Youquan,Song wrote:
> > Change the patch title to short one.
> > David, Couly you please also pick this up? Sorry, if you have done.
> 
> http://git.infradead.org/iommu-2.6.git?commit=e936d0773df
> 
> I changed the title when I committed it.
> 
  Fine, your title is better than mine. Thanks.
