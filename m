Return-Path: <linux-kernel-owner+w=401wt.eu-S1753449AbYLCQye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbYLCQye (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 11:54:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbYLCQyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 11:54:24 -0500
Received: from mga02.intel.com ([134.134.136.20]:57673 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190AbYLCQyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 11:54:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,708,1220252400"; 
   d="scan'208";a="470778522"
Subject: Re: Unusually low speeds with ath5k and iwl3945
From: reinette chatre <reinette.chatre@intel.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Bob Copeland <me@bobcopeland.com>,
       "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
       "ath5k-devel@lists.ath5k.org" <ath5k-devel@venema.h4ckr.net>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "wally@theblackmoor.net" <wally@theblackmoor.net>
In-Reply-To: <492719ED.5000006@gmail.com>
References: <492719ED.5000006@gmail.com>
Content-Type: text/plain
Date: Wed, 03 Dec 2008 08:55:19 -0800
Message-Id: <1228323319.12006.3.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-21 at 12:28 -0800, Maxim Levitsky wrote:

> sorry for cross-posting, but this issue really spans both iwl3945 and ath5k.
> 
> I have two laptops (acer 5720, and aspire one) and I see some strange speed issues.
> 
> I initially blamed iwl3945, then thought it got fixed, but now I have ath5k, and speeds are low
> and I suspect that both drivers has bugs regarding to speed.

We just posted some fixes to iwl3945 rate scaling. Could you please test
with http://marc.info/?l=linux-wireless&m=122824880823630&w=2 ?

Thank you

Reinette


