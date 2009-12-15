Return-Path: <linux-kernel-owner+w=401wt.eu-S1758613AbZLOTm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758613AbZLOTm5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 14:42:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758258AbZLOTmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 14:42:53 -0500
Received: from mga02.intel.com ([134.134.136.20]:41522 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757661AbZLOTmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 14:42:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,401,1257148800"; 
   d="scan'208";a="579189078"
Subject: Re: [stable] [PATCH 2/2] iwlwifi: unify iwl_setup_rxon_timing
From: reinette chatre <reinette.chatre@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Greg KH <greg@kroah.com>, Ike Panhc <ike.pan@canonical.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Winkler, Tomas" <tomas.winkler@intel.com>,
       "stable@kernel.org" <stable@kernel.org>,
       "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>, "Zhu, Yi" <yi.zhu@intel.com>
In-Reply-To: <20091215163100.GC8097@tuxdriver.com>
References: <1260848655-5582-1-git-send-email-ike.pan@canonical.com>
	 <1260848710-5650-1-git-send-email-ike.pan@canonical.com>
	 <20091215041500.GB31200@kroah.com> <4B273479.6050502@canonical.com>
	 <20091215134943.GA11667@kroah.com>  <20091215163100.GC8097@tuxdriver.com>
Content-Type: text/plain
Date: Tue, 15 Dec 2009 11:42:48 -0800
Message-Id: <1260906168.9623.4.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-15 at 08:31 -0800, John W. Linville wrote:
> On Tue, Dec 15, 2009 at 05:49:43AM -0800, Greg KH wrote:
> > On Tue, Dec 15, 2009 at 03:02:17PM +0800, Ike Panhc wrote:
> 
> > > Please consider applying to linux-2.6.31.y
> > 
> > I need the subsystem maintainer to agree with this, have they?
> 
> It seems fine to me.  You may want to let Intel comment too.
> 

No objection here. Even so, I find it strange that this patch fixes a
problem since it really should not have any functional changes. 

I see this patch is 2/2 of a series ... was 1/2 an iwlwifi patch also?

Reinette


