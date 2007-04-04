Return-Path: <linux-kernel-owner+w=401wt.eu-S2993020AbXDDS5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993020AbXDDS5c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993033AbXDDS5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:57:31 -0400
Received: from ns2.g-housing.de ([81.169.133.75]:45670 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993020AbXDDS5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:57:30 -0400
Date: Wed, 4 Apr 2007 19:57:27 +0100 (BST)
From: Christian Kujau <christian@g-house.de>
X-X-Sender: evil@sheep.housecafe.de
To: Francois Romieu <romieu@fr.zoreil.com>
cc: linux-kernel@vger.kernel.org, malte@g-house.de
Subject: Re: 2.6.20.4: NETDEV WATCHDOG and lockups
In-Reply-To: <20070404181010.GA7814@electric-eye.fr.zoreil.com>
Message-ID: <Pine.LNX.4.64.0704041952490.3963@sheep.housecafe.de>
References: <Pine.LNX.4.64.0704022012300.3963@sheep.housecafe.de>
 <20070403205744.GB12969@electric-eye.fr.zoreil.com>
 <Pine.LNX.4.64.0704041342390.3963@sheep.housecafe.de>
 <20070404181010.GA7814@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2007, Francois Romieu wrote:
> No serial cable ?

No, unfortunately this hosting provider does not have a serial console 
to access :(

>>> 4 - try:
>>>   http://www.fr.zoreil.com/linux/kernel/2.6.x/2.6.21-rc5/r8169-20070402
>> Are they in -rc5 yet or 'not in -rc5 but should be applied to -rc5'?
>
> 'not in -rc5 but should be applied to -rc5 though the first two at the
> bottom (000[12]-r8169-blah-blah.patch) are now in latest -git'.

OK, that's something for after-this-weekend then...

Thanks again,
Christian.
-- 
BOFH excuse #68:

only available on a need to know basis
