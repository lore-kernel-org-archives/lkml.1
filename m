Return-Path: <linux-kernel-owner+w=401wt.eu-S1751829AbZJXPjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829AbZJXPjN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 11:39:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751606AbZJXPjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 11:39:13 -0400
Received: from sous-sol.org ([216.99.217.87]:52624 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751581AbZJXPjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 11:39:12 -0400
Date: Sat, 24 Oct 2009 08:38:56 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: "Han, Weidong" <weidong.han@intel.com>
Cc: "'Chris Wright'" <chrisw@sous-sol.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "'iommu@lists.linux-foundation.org'" 
	<iommu@lists.linux-foundation.org>,
       "'David Woodhouse'" <dwmw2@infradead.org>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] intr-remap: allow disabling source id checking
Message-ID: <20091024153856.GD14926@sequoia.sous-sol.org>
References: <20091024012606.GB14926@sequoia.sous-sol.org> <715D42877B251141A38726ABF5CABF2C05509A7677@pdsmsx503.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <715D42877B251141A38726ABF5CABF2C05509A7677@pdsmsx503.ccr.corp.intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Han, Weidong (weidong.han@intel.com) wrote:
> Hi Chris,
> 
> How about get rid of the 'nointremap' option? Therefore keep only one option for interrupt remapping.

I'd prefer that too.  I kept it becauase it's user visible, and has
shipped in 2.6.31.

thanks,
-chris
