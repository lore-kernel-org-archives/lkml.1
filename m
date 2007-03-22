Return-Path: <linux-kernel-owner+w=401wt.eu-S932901AbXCVOZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932901AbXCVOZY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 10:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932954AbXCVOZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 10:25:24 -0400
Received: from hosting4p.com ([81.0.235.160]:42711 "EHLO micron1.hosting4p.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932901AbXCVOZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 10:25:23 -0400
Message-ID: <460291DE.8090403@slax.org>
Date: Thu, 22 Mar 2007 15:25:34 +0100
From: Tomas M <tomas@slax.org>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: max_loop limit
References: <460236CE.1030303@slax.org>	<20070322110058.GB23664@tatooine.rebelbase.local>	<46026A92.4020106@slax.org> <20070322144210.73dfaf83.dada1@cosmosbay.com>
In-Reply-To: <20070322144210.73dfaf83.dada1@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> You might want a more radical patch : 

I agree that my patch is not the perfect solution for max_loop problem.
But it nearly doubles max_loop for me (using 386 arch) and moreover it 
is a FIX for incorrect implementation in kernel IMHO. So I can see 
REASON to include it in Kernel. Do I cry at the correct tomb? :)

> 
> Instead of using :
> ::
> Switch to :
> ::

I'm not any professional kernel hacker, so I don't understand the 
mysteries regarding ** (pointers to pointers?). Is there anyone who 
could provide CLEAN patch for loop.c, which would raise the max_loop 
limit to (at least) 1024 and which would be ACCEPTED to mainline kernel 
any soon?

I'm offering MONEY for this task.
Let's say $256 ;-)
I hope I didn't offend anyone by this offer.



Tomas M
slax.org
