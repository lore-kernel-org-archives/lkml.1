Return-Path: <linux-kernel-owner+w=401wt.eu-S1759296AbZLOEPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759296AbZLOEPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 23:15:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754572AbZLOEPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 23:15:51 -0500
Received: from kroah.org ([198.145.64.141]:34789 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026AbZLOEPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 23:15:51 -0500
Date: Mon, 14 Dec 2009 20:15:00 -0800
From: Greg KH <greg@kroah.com>
To: Ike Panhc <ike.pan@canonical.com>
Cc: kernel-team@lists.ubuntu.com, linux-kernel@vger.kernel.org,
       Tomas Winkler <tomas.winkler@intel.com>, stable@kernel.org,
       Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: Re: [stable] [PATCH 2/2] iwlwifi: unify iwl_setup_rxon_timing
Message-ID: <20091215041500.GB31200@kroah.com>
References: <1260848655-5582-1-git-send-email-ike.pan@canonical.com> <1260848710-5650-1-git-send-email-ike.pan@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260848710-5650-1-git-send-email-ike.pan@canonical.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 11:45:10AM +0800, Ike Panhc wrote:
> This patch unifies setup_rxon_timing funcions
> of AGN and 3945. HWs differ only in supported maximal
> beacon interval. This is reflected in hw_paras.max_beacon_itrvl
> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> (cherry picked from commit 2c2f3b33888419fb9e7d015b9dc67b9db4437efa)
> 
> Conflicts:
> 
> 	drivers/net/wireless/iwlwifi/iwl-dev.h

What does this mean?

> CC: stable@kernel.org
> Signed-off-by: Ike Panhc <ike.pan@canonical.com>
> 
> BugLink: http://bugs.launchpad.net/bugs/496496

What are you expecting this patch to be applied to?

confused,

greg k-h
