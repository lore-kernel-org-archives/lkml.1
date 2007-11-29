Return-Path: <linux-kernel-owner+w=401wt.eu-S933637AbXK2UEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933637AbXK2UEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 15:04:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759914AbXK2UEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 15:04:20 -0500
Received: from rtr.ca ([76.10.145.34]:3973 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757802AbXK2UET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 15:04:19 -0500
Message-ID: <474F1B41.5040302@rtr.ca>
Date: Thu, 29 Nov 2007 15:04:17 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: kristen.c.accardi@intel.com
Cc: jeff@garzik.org, akpm@linux-foundation.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] ata: ahci: Enclosure Management via LED
References: <20071129094802.49e729ed@appleyard>	<474F01E7.5040101@rtr.ca> <20071129112220.55310ff5@appleyard>
In-Reply-To: <20071129112220.55310ff5@appleyard>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kristen Carlson Accardi wrote:
> On Thu, 29 Nov 2007 13:16:07 -0500
> Mark Lord <lkml@rtr.ca> wrote:
> 
>> Kristen wrote:
>> ...
>>> +	 * XXX will need Port Multiplier support
>> What's that all about ?
>>
> 
> I didn't have any hardware that had LED support as well as Port
> Multiplier, so I didn't implement port multiplier support for this.  I
> wasn't sure if it was better to just do it anyway, or leave it for when
> we actually have hardware that needs it.
..

Good.  So please replace the "XXX" comment with the better
explanation given in your posting above.  That'll make future
maintenance a lot less guessy.

Cheers
