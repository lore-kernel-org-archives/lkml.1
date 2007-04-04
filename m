Return-Path: <linux-kernel-owner+w=401wt.eu-S934086AbXDDSM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934086AbXDDSM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932167AbXDDSMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:12:52 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:49512 "EHLO
	fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934087AbXDDSMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:12:37 -0400
Date: Wed, 4 Apr 2007 20:10:10 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Christian Kujau <christian@g-house.de>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, malte@g-house.de
Subject: Re: 2.6.20.4: NETDEV WATCHDOG and lockups
Message-ID: <20070404181010.GA7814@electric-eye.fr.zoreil.com>
References: <Pine.LNX.4.64.0704022012300.3963@sheep.housecafe.de> <20070403205744.GB12969@electric-eye.fr.zoreil.com> <Pine.LNX.4.64.0704041342390.3963@sheep.housecafe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704041342390.3963@sheep.housecafe.de>
User-Agent: Mutt/1.4.2.1i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Kujau <christian@g-house.de> :
[...]
> Actually I was thinking about *using* netconsole, since even setting up 
> remote (userspace-)syslog left nothing on the syslog-server, when the 
> machine crashed. But if it's b0rked in 8139, I will refrain from doing 
> so.

Please refrain :o)

No serial cable ?

> >4 - try:
> >   http://www.fr.zoreil.com/linux/kernel/2.6.x/2.6.21-rc5/r8169-20070402
> 
> Are they in -rc5 yet or 'not in -rc5 but should be applied to -rc5'?

'not in -rc5 but should be applied to -rc5 though the first two at the
bottom (000[12]-r8169-blah-blah.patch) are now in latest -git'.

-- 
Ueimor
