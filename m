Return-Path: <linux-kernel-owner+w=401wt.eu-S1755923AbYFQBLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923AbYFQBLy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 21:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbYFQBLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 21:11:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:33750 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384AbYFQBLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 21:11:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,655,1204531200"; 
   d="scan'208";a="398076513"
Subject: Re: [2.6.26-rc5] iwlwifi 4965 not working - last on 2.6.23
From: Zhu Yi <yi.zhu@intel.com>
To: =?UTF-8?Q?Micha=C5=82_Kud=C5=82a?= <michal.kudla@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
In-Reply-To: <200806162021.37105.Michal.Kudla@gmail.com>
References: <200806060039.48488.m1k0@wp.pl>
	 <200806131937.03680.Michal.Kudla@gmail.com>
	 <1213581088.7814.882.camel@debian.sh.intel.com>
	 <200806162021.37105.Michal.Kudla@gmail.com>
Content-Type: text/plain; charset=UTF-8
Organization: Intel Corp.
Date: Tue, 17 Jun 2008 09:11:28 +0800
Message-Id: <1213665088.2533.24.camel@debian.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-16 at 20:21 +0200, Michał Kudła wrote:
> And my wifi working!
> 
> Bt, I don't know why my wifi working under 2.6.23 and 2.6.24?

mac80211 in those (old) kernels doesn't indicate to switch the SW
rf_kill on with user sets txpower off.

Thanks,
-yi

