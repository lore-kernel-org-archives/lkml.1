Return-Path: <linux-kernel-owner+w=401wt.eu-S1758981AbYFMHyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758981AbYFMHyz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 03:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754112AbYFMHyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 03:54:45 -0400
Received: from mga11.intel.com ([192.55.52.93]:27395 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753508AbYFMHyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 03:54:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,637,1204531200"; 
   d="scan'208";a="339918546"
Subject: Re: [2.6.26-rc5] iwlwifi 4965 not working - last on 2.6.23
From: Zhu Yi <yi.zhu@intel.com>
To: =?UTF-8?Q?Micha=C5=82_Kud=C5=82a?= <michal.kudla@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
In-Reply-To: <200806112117.01544.Michal.Kudla@gmail.com>
References: <200806060039.48488.m1k0@wp.pl>
	 <20080606034738.9835782d.akpm@linux-foundation.org>
	 <1213151464.7814.630.camel@debian.sh.intel.com>
	 <200806112117.01544.Michal.Kudla@gmail.com>
Content-Type: text/plain; charset=UTF-8
Organization: Intel Corp.
Date: Fri, 13 Jun 2008 15:54:21 +0800
Message-Id: <1213343661.7814.868.camel@debian.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-11 at 21:17 +0200, Michał Kudła wrote:
> Still don't work.
> I have tested this patch with and without RFKILL kernel settings
> Compressed result files:
> config-2.6.26-rc5-no-rfkill.txt
> config-2.6.26-rc5-rfkill.txt
> dmesg-2.6.26-rc5-no-rfkill.txt
> dmesg-2.6.26-rc5-rfkill.txt
> are in
> http://michal.kudla.googlepages.com/iwlwifi-problem-with-patch-Zhu-Yi.ta.bz2

Can you please load the module with "debug=0x20002" and attached the
dmesg?

Thanks,
-yi

