Return-Path: <linux-kernel-owner+w=401wt.eu-S965326AbXBLTRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965326AbXBLTRp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 14:17:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965323AbXBLTRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 14:17:45 -0500
Received: from mga06.intel.com ([134.134.136.21]:17344 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965318AbXBLTRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 14:17:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,316,1167638400"; 
   d="scan'208"; a="195871161:sNHT21501697"
Message-ID: <45D0B363.8070303@linux.intel.com>
Date: Mon, 12 Feb 2007 10:35:15 -0800
From: James Ketrenos <jketreno@linux.intel.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070104)
MIME-Version: 1.0
To: "Hesse, Christian" <mail@earthworm.de>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       ipw3945-devel@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [ANNOUNCE] d80211 based driver for Intel PRO/Wireless 3945ABG
References: <45CCE3CA.4050904@linux.intel.com> <200702101424.00156.mail@earthworm.de> <200702101525.56820.mail@earthworm.de>
In-Reply-To: <200702101525.56820.mail@earthworm.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hesse, Christian wrote:
> On Saturday 10 February 2007 14:23, Hesse, Christian wrote:
>> On Friday 09 February 2007 22:12, James Ketrenos wrote:
>>> We are pleased to announce the availability of a new driver for the
>>> Intel PRO/Wireless 3945ABG Network Connection adapter.
...
> Oh, I forgot one note: "make patch_kernel" is terribly broken. Any chance to 
> get this fixed soon?

I've put up a new version of iwlwifi (0.0.6) with significant changes to 
the patch_kernel scripts as well as including Pavel's patch to KSRC.

I performed some build testing with 2.6.18 and wireless-dev @ commit 
f66e5aaa88c1c0a7ee6c6427d6535ed8afd35427 (Jan 8).

http://intellinuxwireless.org/?n=downloads

Let me know if it is still breaking.

Thanks,
James
