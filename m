Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab0BSU56 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 15:57:58 -0500
Received: from mga11.intel.com ([192.55.52.93]:14997 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756094Ab0BSU5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 15:57:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,505,1262592000"; 
   d="scan'208";a="774263265"
Subject: Re: [patch] iwlwifi: testing the wrong variable
From: reinette chatre <reinette.chatre@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Dan Carpenter <error27@gmail.com>, "Zhu, Yi" <yi.zhu@intel.com>,
       Intel Linux Wireless <ilw@linux.intel.com>,
       "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
       "Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
In-Reply-To: <20100219203039.GN4950@tuxdriver.com>
References: <20100218094529.GA1298@bicker>
	 <1266516282.2551.2604.camel@rchatre-DESK>
	 <20100219203039.GN4950@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Feb 2010 12:57:54 -0800
Message-ID: <1266613074.2551.2807.camel@rchatre-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-19 at 12:30 -0800, John W. Linville wrote:
> So for the record, that patch is basically identical to Dan's patch
> but with some whitespace fixups in some nearby lines as well.
> 
> How important is this patch?  Is there an actual bug report?  Is it
> a regression?
> 
> It is very late in the 2.6.33 cycle and it isn't obvious to me that
> this is worth pushing for 2.6.33 at this point...?

This is exactly the reason why we did not post the patch to 2.6.33 or
stable when we submitted it upstream since there was no regression or
bug tied to it at that time. It surely is a problem that needs fixing,
which we did in the current release. I just highlighted that if there is
a request for this to be fixed in stable then we already have the patch
available. I'm ok with this one only going into 2.6.34.

Reinette


