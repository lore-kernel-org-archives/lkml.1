Return-Path: <linux-kernel-owner+w=401wt.eu-S1760005AbYFZU6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760005AbYFZU6B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 16:58:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754675AbYFZU5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 16:57:49 -0400
Received: from mail.rz.uni-duesseldorf.de ([134.99.128.30]:49475 "EHLO
	mail.rz.uni-duesseldorf.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753811AbYFZU5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 16:57:48 -0400
Date: Thu, 26 Jun 2008 22:57:41 +0200 (CEST)
From: Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>
Subject: Re: [2.6 patch] remove the dead ATARI_SCC{,_DMA} options
In-reply-to: <Pine.LNX.4.64.0806260909490.30924@anakin>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>,
       Adrian Bunk <bunk@kernel.org>, zippel@linux-m68k.org,
       linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Robert P. J. Day" <rpjday@crashcourse.ca>
Message-id: <alpine.DEB.1.00.0806262240480.9169@zirkon.biophys.uni-duesseldorf.de>
MIME-version: 1.0
Content-type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Content-transfer-encoding: 7BIT
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
References: <20080625162536.GH10285@cs181140183.pp.htv.fi>
 <alpine.DEB.1.00.0806260644080.30738@zirkon.biophys.uni-duesseldorf.de>
 <Pine.LNX.4.64.0806260909490.30924@anakin>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

>> A revived Atari SCC serial driver should be in Geert's patch queue, or in the
>
> ... which needs some rework before it can be submitted, I'm afraid (I can
> take care of the checkpatch warnings, though ;-)

What sort of work, apart from checkpatch cleanup?

>> m68k kernel tree. The SCC_DMA option, however, is dead and can be removed.
>
> So I think it's safe to apply the whole patch, and readd
> CONFIG_ATARI_SCC together with the new driver.

Just remember to add the option to my patch :-)

Thanks,

 	Michael

