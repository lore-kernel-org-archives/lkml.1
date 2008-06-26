Return-Path: <linux-kernel-owner+w=401wt.eu-S1757294AbYFZGAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294AbYFZGAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 02:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755162AbYFZGAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 02:00:08 -0400
Received: from mail.rz.uni-duesseldorf.de ([134.99.128.30]:43788 "EHLO
	mail.rz.uni-duesseldorf.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754896AbYFZGAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 02:00:06 -0400
X-Greylist: delayed 4453 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Jun 2008 02:00:06 EDT
Date: Thu, 26 Jun 2008 06:45:46 +0200 (CEST)
From: Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>
Subject: Re: [2.6 patch] remove the dead ATARI_SCC{,_DMA} options
In-reply-to: <20080625162536.GH10285@cs181140183.pp.htv.fi>
To: Adrian Bunk <bunk@kernel.org>
Cc: geert@linux-m68k.org, zippel@linux-m68k.org, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Robert P. J. Day" <rpjday@crashcourse.ca>
Message-id: <alpine.DEB.1.00.0806260644080.30738@zirkon.biophys.uni-duesseldorf.de>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Content-transfer-encoding: 7BIT
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
References: <20080625162536.GH10285@cs181140183.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It seems the driver was removed back in kernel 2.3 but the options were
> forgotten.
>
> Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

A revived Atari SCC serial driver should be in Geert's patch queue, or in 
the m68k kernel tree. The SCC_DMA option, however, is dead and can be 
removed.

Cheers,

 	Michael

