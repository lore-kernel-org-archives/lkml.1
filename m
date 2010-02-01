Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066Ab0BANOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 08:14:20 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55316
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751838Ab0BANOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 08:14:18 -0500
Date: Mon, 01 Feb 2010 05:14:32 -0800 (PST)
Message-Id: <20100201.051432.226757615.davem@davemloft.net>
To: alan@lxorguk.ukuu.org.uk
Cc: jeff@garzik.org, bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/68] ide2libata
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100201125845.3f468363@lxorguk.ukuu.org.uk>
References: <20100201114824.29682015@lxorguk.ukuu.org.uk>
	<20100201.044813.27473014.davem@davemloft.net>
	<20100201125845.3f468363@lxorguk.ukuu.org.uk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Mon, 1 Feb 2010 12:58:45 +0000

>> > The old drivers contain a fair amount of crap, magic and gueswork so a
>> > good deal of human analysis and testing is needed to move any change
>> > around and prove it's real and valid not guesswork and fudging.
>> 
>> And then once that hard work is done, we kind of just toss it
>> for one side of the equation?
> 
> I don't where you got that idea from.
> 
> The "merge" makes it harder to maintain both, adds lots of ifdefs and
> artificial divisions of code stuffed into include files. Its ugly as sin
> and makes *both* sets of drivers harder to maintain.

I have not advocated the ifdef implementation.

I have advocated one where the data structures are actually
the same, and there are no ifdefs.

Please reread my initial reply.
