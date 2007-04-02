Return-Path: <linux-kernel-owner+w=401wt.eu-S965990AbXDBWHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965990AbXDBWHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 18:07:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965993AbXDBWHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 18:07:09 -0400
Received: from ns2.g-housing.de ([81.169.133.75]:55116 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965992AbXDBWHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 18:07:07 -0400
X-Greylist: delayed 3093 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Apr 2007 18:07:07 EDT
Date: Mon, 2 Apr 2007 22:15:27 +0100 (BST)
From: Christian Kujau <christian@g-house.de>
X-X-Sender: evil@sheep.housecafe.de
To: Chuck Ebbert <cebbert@redhat.com>
cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, malte@g-house.de
Subject: Re: 2.6.20.4: NETDEV WATCHDOG and lockups
In-Reply-To: <46116570.3050109@redhat.com>
Message-ID: <Pine.LNX.4.64.0704022212490.3963@sheep.housecafe.de>
References: <Pine.LNX.4.64.0704022012300.3963@sheep.housecafe.de>
 <46116570.3050109@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Apr 2007, Chuck Ebbert wrote:
>> Please see http://nerdbynature.de/bits/2.6.20.4/ for details for both
>> hosts and feel free to ask for more details. Although both boxes are in
>> production we'll be happy test more bootoptions/patches and the like.
>
> Where is the info from before you changed to "noapic"? Or were the
> machines always using XT-PIC for all the interrupts???

Who, didn't notice the XT-PIC in /proc/interrupts. From the count of 
your questionmarks I figure it's a bad thing then?

@Malte, do we still have this information around?

Thanks,
Christian.
-- 
BOFH excuse #63:

not properly grounded, please bury computer
