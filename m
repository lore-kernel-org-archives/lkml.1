Return-Path: <linux-kernel-owner+w=401wt.eu-S1759478AbXIXRDC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759478AbXIXRDC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 13:03:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762010AbXIXRCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 13:02:49 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:37198 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758562AbXIXRCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 13:02:48 -0400
Date: Mon, 24 Sep 2007 22:43:24 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       dmitry.adamushko@gmail.com, linux-kernel@vger.kernel.org,
       dhaval@linux.vnet.ibm.com, containers@lists.osdl.org,
       kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, efault@gmx.de
Subject: Re: [PATCH 3/5] Cleanup code under CONFIG_FAIR_GROUP_SCHED
Message-ID: <20070924171324.GG5657@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20070924163326.GA10291@linux.vnet.ibm.com> <20070924163937.GD10291@linux.vnet.ibm.com> <20070924095344.ee9ab10e.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070924095344.ee9ab10e.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2007 at 09:53:44AM -0700, Randy Dunlap wrote:
> >  config FAIR_GROUP_SCHED
> > -	bool "Fair group scheduler"
> > -	depends on EXPERIMENTAL && CONTAINERS
> > +	bool "Fair group cpu scheduler"
> 
> Can we have "CPU" instead of "cpu" ?

Sounds good. Will add to my follow-on.patch (and will send out after
others have had a chance to comment).

-- 
Regards,
vatsa
