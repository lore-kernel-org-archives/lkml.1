Return-Path: <linux-kernel-owner+w=401wt.eu-S934459AbXILVX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934459AbXILVX7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 17:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934349AbXILVVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 17:21:49 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:39309 "EHLO
	fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765795AbXILVVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 17:21:47 -0400
Date: Wed, 12 Sep 2007 23:20:25 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Xavier Bestel <xavier.bestel@free.fr>
Cc: linux-kernel@vger.kernel.org, shuchen@realtek.com.tw
Subject: Re: r8169: can't send magic packet for Wake-On-Lan
Message-ID: <20070912212025.GA30315@electric-eye.fr.zoreil.com>
References: <1189545366.4403.9.camel@bip.parateam.prv> <20070911213017.GA661@electric-eye.fr.zoreil.com> <1189571526.6098.1.camel@bip.parateam.prv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1189571526.6098.1.camel@bip.parateam.prv>
User-Agent: Mutt/1.4.2.1i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Xavier Bestel <xavier.bestel@free.fr> :
[...]
> Err sorry, I mixed up everything ... I'm using *etherwake* to make the
> WOL magic packet, and ethtool to check the interface options.

Weird.

Can you capture the traffic from the receiving (live) r8169 whith
both senders and specify the kernel version of the sender/receiver ?

-- 
Ueimor
