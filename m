Return-Path: <linux-kernel-owner+w=401wt.eu-S1757341AbZEVR7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341AbZEVR7U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 13:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbZEVR7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 13:59:07 -0400
Received: from lvps87-230-0-242.dedicated.hosteurope.de ([87.230.0.242]:47361
	"EHLO lvps87-230-0-242.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751729AbZEVR7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 13:59:06 -0400
Cc: David Miller <davem@davemloft.net>, buytenh@wantstofly.org,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       netdev@vger.kernel.org
Message-Id: <D8767624-24E6-49B7-BC0A-084435C8DDAC@it-loops.com>
From: Michael Guntsche <mike@it-loops.com>
To: Andy Fleming <afleming@freescale.com>
In-Reply-To: <C6E445A9-0CE7-4270-848E-6FB34B3271D5@freescale.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v935.3)
Subject: Re: [BUG] 2.6.30-rc4: Kernel BUG under network load with gianfar
Date: Fri, 22 May 2009 19:59:01 +0200
References: <50F164E7-D247-4FD6-B41B-BDAA8681166B@it-loops.com> <20090520214734.GA11277@mail.wantstofly.org> <20090521.152439.79009648.davem@davemloft.net> <9E304569-5828-403D-B4B0-845D8F0D6B95@it-loops.com> <C6E445A9-0CE7-4270-848E-6FB34B3271D5@freescale.com>
X-Mailer: Apple Mail (2.935.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 22, 2009, at 19:18, Andy Fleming wrote:

> I'm working (admittedly fairly slowly) on a patch that resets the  
> pointers so they don't get moved twice.  That way we can continue to  
> benefit from recycling the error skbs.

Ok, thanks for the information. Just tell me when you have a patch  
ready for testing, since it's fairly easy for me to reproduce this  
here with my setup. I'll keep Lennard's patch in the meantime.

Kind regards,
Michael
