Return-Path: <linux-kernel-owner+w=401wt.eu-S1763788AbZLQBwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763788AbZLQBwi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:52:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763289AbZLQBwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:52:32 -0500
Received: from adelie.canonical.com ([91.189.90.139]:48620 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759686AbZLQBwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:52:30 -0500
Message-ID: <4B298ECF.7050009@canonical.com>
Date: Thu, 17 Dec 2009 09:52:15 +0800
From: Ike Panhc <ike.pan@canonical.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: reinette chatre <reinette.chatre@intel.com>
CC: Greg KH <greg@kroah.com>, "John W. Linville" <linville@tuxdriver.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Winkler, Tomas" <tomas.winkler@intel.com>,
       "stable@kernel.org" <stable@kernel.org>,
       "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>, "Zhu, Yi" <yi.zhu@intel.com>
Subject: Re: [stable] [PATCH 2/2] iwlwifi: unify iwl_setup_rxon_timing
References: <1260848655-5582-1-git-send-email-ike.pan@canonical.com>	 <1260848710-5650-1-git-send-email-ike.pan@canonical.com>	 <20091215041500.GB31200@kroah.com> <4B273479.6050502@canonical.com>	 <20091215134943.GA11667@kroah.com> <20091215163100.GC8097@tuxdriver.com>	 <1260906168.9623.4.camel@rc-desk> <20091215194938.GA13297@kroah.com>	 <4B288232.4060901@canonical.com> <1260983101.9623.11.camel@rc-desk>
In-Reply-To: <1260983101.9623.11.camel@rc-desk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reinette chatre wrote:
> On Tue, 2009-12-15 at 22:46 -0800, Ike Panhc wrote:
> 
>> But Please consider applying the first patch (change IWL6000_UCODE_API_MAX
>> to v4) to 2.6.31-stable tree. It will be good to use v4 firmware on iwl6000.
> 
> Please no. This will effectively enable 6000 series in 2.6.31. We did
> not target 2.6.31 for 6000 series enabling and more patches, which are
> in 2.6.32, are required for 6000 series to work well.
> 
> Reinette
> 
Got it, so backport any patch for iwl6000 to 2.6.31-stable is not reasonable.

