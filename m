Return-Path: <linux-kernel-owner+w=401wt.eu-S1753286AbXITXDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbXITXDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 19:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751275AbXITXDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 19:03:08 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51616 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbXITXDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 19:03:07 -0400
Date: Fri, 21 Sep 2007 01:03:04 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Matt Mackall <mpm@selenic.com>
Cc: Dave Airlie <airlied@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: X-freeze after clflush changes [Was: 2.6.23-rc6-mm1]
Message-ID: <20070920230304.GJ18707@one.firstfloor.org>
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <46F10B69.5070008@gmail.com> <46F10DCB.1090302@gmail.com> <46F13938.1070709@gmail.com> <20070919121017.0cbcbc30.akpm@linux-foundation.org> <20070919192453.GB18707@one.firstfloor.org> <21d7e9970709191842h3111390cl8f09745bed6bd8f9@mail.gmail.com> <20070920220604.GA17536@waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070920220604.GA17536@waste.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> It's broken for me.
> 
> 2.6.23-rc3-mm1: solid lock on X shutdown (noticed when upgrading)
>       -rc4-mm1: solid lock on X shutdown, random solid locks about
>                 once every four hours
>       -rc6-mm1: solid lock on X startup
>    +your patch: screen goes black, turns off and on a few times during
>                 startup, can reboot with sysrq-b

Does it work with my simple dumb patch instead of Dave's ? 

-Andi
