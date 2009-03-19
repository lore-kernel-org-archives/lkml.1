Return-Path: <linux-kernel-owner+w=401wt.eu-S1760010AbZCSRM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760010AbZCSRM7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 13:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755428AbZCSRMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 13:12:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:23865 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754152AbZCSRMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 13:12:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,389,1233561600"; 
   d="scan'208";a="499163764"
Subject: Re: [patch 0/5] Intel Poulsbo/Morrestown DRM driver and DRM core 
	changes
From: Richard Purdie <rpurdie@linux.intel.com>
To: Sindhudweep Sarkar <sindhudweep.sarkar@gmail.com>
Cc: Greg KH <greg@kroah.com>, David Airlie <airlied@linux.ie>,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Thomas Hellstrom <thellstrom@vmware.com>
In-Reply-To: <6c046ab30903190903r298a0334n939e64403b8aeda6@mail.gmail.com>
References: <20090319040809.GA29249@kroah.com>
	 <6c046ab30903190903r298a0334n939e64403b8aeda6@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 19 Mar 2009 17:12:56 +0000
Message-Id: <1237482776.5359.89.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2009-03-19 at 12:03 -0400, Sindhudweep Sarkar wrote:
> This might be the opinion of a completely non educated end user but it
> seems that an intel specific drm and other bits (xorg, mesa) would be
> somewhat of a maintenance waste.
> 
> TI-OMAP 3xxx and a couple of other arm processors use similar SGX-5xx
> graphics cores. IIRC arm is often little endian so perhaps a unified
> driver would be easier in the long term.

Long term a unified driver would be very nice to have and nobody
disagrees with that. Things don't happen overnight and you have to take
smaller steps to get there. This proposal is one step on a road that may
lead to a driver for the TI part too. It will need someone in the ARM
community to step up and write the ARM specific bits.

Cheers,

Richard

