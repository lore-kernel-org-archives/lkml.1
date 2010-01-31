Return-Path: <linux-kernel-owner+w=401wt.eu-S1754237Ab0AaUNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab0AaUNe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 15:13:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753998Ab0AaUNd
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 15:13:33 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:15367 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754049Ab0AaUNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 15:13:32 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sun, 31 Jan 2010 15:13:31 EST
Message-ID: <4B65E330.3040000@bluewatersys.com>
Date: Mon, 01 Feb 2010 09:08:16 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Remy Bohmer <linux@bohmer.net>
CC: Harro Haan <hrhaan@gmail.com>, Andrew Victor <avictor.za@gmail.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       H Hartley Sweeten <hartleys@visionengravers.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v2 1/2] at91_udc.c read_fifo timing issue
References: <20100129162029.998540038@gmail.com>	 <20100129162155.709756286@gmail.com> <3efb10971001290904p74b1919aif8ff013f050123a9@mail.gmail.com>
In-Reply-To: <3efb10971001290904p74b1919aif8ff013f050123a9@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remy Bohmer wrote:
> Hi Harro,
> 
> 2010/1/29 Harro Haan <hrhaan@gmail.com>:
>> This solves the read_fifo timing issue for example seen with CDC Ethernet.
>> See the comments below for more info.
>>
>> Signed-off-by: Harro Haan <hrhaan@gmail.com>
>> ---
>>  drivers/usb/gadget/at91_udc.c |   46 ++++++++++++++++++++++++++++++++++++++----
>>  1 file changed, 42 insertions(+), 4 deletions(-)
>>
> Acked-by: Remy Bohmer <linux@bohmer.net>

Can I get your Acked-by for my patch also Remy?

Harro, I can either submit my patch to the patch system separately, or
you can put it through with your series with my From/Signed-off-by tag
on it.

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
