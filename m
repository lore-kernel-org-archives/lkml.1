Return-Path: <linux-kernel-owner+w=401wt.eu-S933289AbXJQWRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933289AbXJQWRY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 18:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759146AbXJQWRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 18:17:16 -0400
Received: from client062.sevenl.net ([66.241.137.62]:3695 "EHLO pcburn.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759117AbXJQWRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 18:17:15 -0400
Message-ID: <471689DA.4070008@pcburn.com>
Date: Wed, 17 Oct 2007 18:16:58 -0400
From: Chris Bergeron <chris@pcburn.com>
Reply-To: chris@pcburn.com
Organization: PCBurn Media
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrey Panin <pazke@donpac.ru>
Subject: Re: Syba 8-Port Serial Card Unidentified By Kernel
References: <4706AD19.4040605@pcburn.com> <20071010095432.GC30345@pazke.donpac.ru> <470E5714.4040303@pcburn.com> <20071012120826.GB23378@pazke.donpac.ru> <47150B06.3040306@pcburn.com> <20071017064219.GB1953@pazke.donpac.ru>
In-Reply-To: <20071017064219.GB1953@pazke.donpac.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Panin wrote:
>
> Is it possible to connect two ports and run getty on one port and minicom on
> another ? We should check that UARTs are really working.
>
>   
I used the on-board serial port as a known working control (after 
getting it to work with the other onboard serial port) to try and 
connect over to one of the Syba card ports (using Cutecom & getty).  The 
lines light up, but there's nothing getting sent from the 8-port as far 
as I can see.  The onboard port works as I'd expect, the Syba (running 
getty identically from inittab) doesn't.

-- Chris


