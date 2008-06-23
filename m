Return-Path: <linux-kernel-owner+w=401wt.eu-S1756899AbYFWFxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899AbYFWFxl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 01:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670AbYFWFxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 01:53:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:52286 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424AbYFWFxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 01:53:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,688,1204531200"; 
   d="scan'208";a="400773452"
Subject: Re: [2.6.26-rc5] iwlwifi 4965 not working - last on 2.6.23
From: Zhu Yi <yi.zhu@intel.com>
To: =?UTF-8?Q?Micha=C5=82_Kud=C5=82a?= <michal.kudla@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
In-Reply-To: <200806230732.44159.Michal.Kudla@gmail.com>
References: <200806060039.48488.m1k0@wp.pl>
	 <200806230530.44283.Michal.Kudla@gmail.com>
	 <1214197551.14590.148.camel@debian.sh.intel.com>
	 <200806230732.44159.Michal.Kudla@gmail.com>
Content-Type: text/plain; charset=UTF-8
Organization: Intel Corp.
Date: Mon, 23 Jun 2008 13:52:46 +0800
Message-Id: <1214200366.14590.150.camel@debian.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-23 at 07:32 +0200, Michał Kudła wrote:
> With "0" and "1" result the same - failed.

Please post the dmesg with debug=0x20002 before and after you echo "1"
to rfkill.

Thanks,
-yi

