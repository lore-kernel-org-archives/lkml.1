Return-Path: <linux-kernel-owner+w=401wt.eu-S1764070AbZFLKPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764070AbZFLKPk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 06:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763730AbZFLKPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 06:15:22 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54848 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764090AbZFLKPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 06:15:21 -0400
Date: Fri, 12 Jun 2009 12:23:20 +0200
From: Andi Kleen <andi@firstfloor.org>
To: James Morris <jmorris@namei.org>
Cc: Joseph Cihula <joseph.cihula@intel.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com, hpa@zytor.com,
       andi@firstfloor.org, Chris Wright <chrisw@sous-sol.org>,
       jbeulich@novell.com, peterm@redhat.com, gang.wei@intel.com,
       shane.wang@intel.com
Subject: Re: [RFC v4][PATCH 2/2] intel_txt: Intel(R) TXT and tboot kernel support
Message-ID: <20090612102320.GI25568@one.firstfloor.org>
References: <4A299051.40405@intel.com> <alpine.LRH.2.00.0906121509001.14633@tundra.namei.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0906121509001.14633@tundra.namei.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 03:12:59PM +1000, James Morris wrote:
> On Fri, 5 Jun 2009, Joseph Cihula wrote:
> 
> > Linux support for Intel(R) Trusted Execution Technology.
> 
> > Signed-off-by:  Joseph Cihula <joseph.cihula@intel.com>
> > Signed-off-by:  Shane Wang <shane.wang@intel.com>
> > Signed-off-by:  Gang Wei <gang.wei@intel.com>
> 
> Reviewed-by: James Morris <jmorris@namei.org>

The earlier version was also reviewed by me and I think Joe addressed
all my concerns. 

So it's

Reviewed-by: Andi Kleen <ak@linux.intel.com>

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
