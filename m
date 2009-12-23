Return-Path: <linux-kernel-owner+w=401wt.eu-S1757390AbZLWWPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390AbZLWWPA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 17:15:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756501AbZLWWO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 17:14:59 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42896
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755992AbZLWWO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 17:14:58 -0500
Date: Wed, 23 Dec 2009 14:14:58 -0800 (PST)
Message-Id: <20091223.141458.193725880.davem@davemloft.net>
To: hartleys@visionengravers.com
Cc: buytenh@wantstofly.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, joe@perches.com
Subject: Re: [PATCH] ep93xx_eth.c: general cleanup
From: David Miller <davem@davemloft.net>
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE19090200ED18@mi8nycmail19.Mi8.com>
References: <BD79186B4FD85F4B8E60E381CAEE19090200ED0C@mi8nycmail19.Mi8.com>
	<20091216183200.GN1819@mail.wantstofly.org>
	<BD79186B4FD85F4B8E60E381CAEE19090200ED18@mi8nycmail19.Mi8.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H Hartley Sweeten" <hartleys@visionengravers.com>
Date: Wed, 16 Dec 2009 13:34:55 -0500

> Wednesday, December 16, 2009 11:32 AM, Lennert Buytenhek wrote:
>> On Wed, Dec 16, 2009 at 01:18:13PM -0500, H Hartley Sweeten wrote:
>>
>>> V3 - Change pr_fmt() as suggested by Joe Perches
>>>      Don't remove DRV_MODULE_NAME and DRV_MODULE_VERSION
>>>      Don't remove the message in ep93xx_eth_init_module()
>>
>> That's not what I meant, but alright, as you prefer.
> 
> Guess my parser is off line today.... ;-)
> 
> What did you mean?

This patch also doesn't apply to current sources, so if you
could also please respin this once you've resolved the feedback
that would be great.

Thanks.
