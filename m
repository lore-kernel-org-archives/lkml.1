Return-Path: <linux-kernel-owner+w=401wt.eu-S1753359AbXFNGDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359AbXFNGDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 02:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751724AbXFNGDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 02:03:24 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:35373 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbXFNGDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 02:03:23 -0400
Date: Thu, 14 Jun 2007 09:03:22 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Wang Zhenyu <zhenyu.z.wang@intel.com>
cc: Dave Jones <davej@redhat.com>, Wang Zhenyu <zhen78@gmail.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Eric Anholt <eric@anholt.net>
Subject: Re: I815 suddenly unkown to agpgart?
In-Reply-To: <20070614020104.GB31534@zhen-devel.sh.intel.com>
Message-ID: <Pine.SOC.4.64.0706140902390.24211@math>
References: <Pine.SOC.4.64.0706131804180.2614@math> <20070613160152.GC3875@redhat.com>
 <20070613161513.GE3875@redhat.com> <20070613180039.GA4508@localhost.localdomain>
 <20070613182240.GA3726@redhat.com> <20070614013412.GA31534@zhen-devel.sh.intel.com>
 <20070614020104.GB31534@zhen-devel.sh.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> oop, for 945GME like case, we should stop scan if still no detection. 
> Updated patch here. 
> 
> [AGPGART] intel_agp: fix device probe

Thanks, this also works on i815+ATI AGP.

-- 
Meelis Roos (mroos@linux.ee)
