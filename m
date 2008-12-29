Return-Path: <linux-kernel-owner+w=401wt.eu-S1755690AbYL2BfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690AbYL2BfM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 20:35:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751124AbYL2Be5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 20:34:57 -0500
Received: from mga01.intel.com ([192.55.52.88]:39654 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbYL2Be4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 20:34:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,293,1228118400"; 
   d="scan'208";a="418168963"
Subject: Re: Firmware errors with ipw2200 when connected to an WPA-enabled
 AP
From: Zhu Yi <yi.zhu@intel.com>
To: Mihai Moldovan <ionic@ionic.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       James Ketrenos <jketreno@linux.intel.com>,
       "Chatre, Reinette" <reinette.chatre@intel.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4954D478.8090408@ionic.de>
References: <495443E6.404@ionic.de> <1230260706.27521.15.camel@debian>
	 <4954D478.8090408@ionic.de>
Content-Type: text/plain
Date: Mon, 29 Dec 2008 09:33:55 +0800
Message-Id: <1230514435.6688.15.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-12-26 at 20:56 +0800, Mihai Moldovan wrote:
> So is this all actually known and no bug? Whilst the connection drops
> in
> idle mode are doing no harm, the sporadic problems on full load are
> some
> sort of a problem because no traffic is transfered for some seconds,
> although the connections per se remain intact.
> 
> Or... well, is this simply not fixable? :)

It is a bug. Should be related to firmware. We can fix it but it takes
some time.

Thanks,
-yi

