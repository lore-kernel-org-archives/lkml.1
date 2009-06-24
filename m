Return-Path: <linux-kernel-owner+w=401wt.eu-S1754926AbZFXWrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926AbZFXWrS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 18:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752302AbZFXWrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 18:47:07 -0400
Received: from 130.120.124.202.static.snap.net.nz ([202.124.120.130]:39740
	"EHLO hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750854AbZFXWrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 18:47:06 -0400
Message-ID: <4A42AD76.8040303@bluewatersys.com>
Date: Thu, 25 Jun 2009 10:49:26 +1200
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Linus Walleij <linus.ml.walleij@gmail.com>
CC: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       spi-devel-general@lists.sourceforge.net, mike@steroidmicros.com,
       linux kernel <linux-kernel@vger.kernel.org>, dedekind@infradead.org
Subject: Re: [PATCH] SST25L (non JEDEC) SPI Flash driver
References: <4A3F017B.2010409@bluewatersys.com>	 <63386a3d0906220122x31d0b23fk7bd86145b719d9b5@mail.gmail.com>	 <4A3FFE02.8020001@bluewatersys.com>	 <63386a3d0906230004m66360f4fhbdc80c8e552a01d0@mail.gmail.com>	 <4A413F8F.6030500@bluewatersys.com> <63386a3d0906241543n16da1f0gc988738f9efd8782@mail.gmail.com>
In-Reply-To: <63386a3d0906241543n16da1f0gc988738f9efd8782@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote:
> 2009/6/23 Ryan Mallon <ryan@bluewatersys.com>:
> 
>> BTW, most of my other patches go via the ARM list, which uses the patch
>> system. Whats the procedure for most other lists, do patches just get
>> collected by the subsection maintainer when they are okay?
> 
> That's the most typical procedure, however I think the SPI maintainer
> (David) has been busy with other things so I merged the PL022
> driver through the ARM tree instead. Another possibility is to send
> it off to Andrew Mortons tree I guess.

Can I get your acked-by and then just CC Andrew Morton?

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

       Ryan Mallon                              Unit 5, Amuri Park
       Phone: +64 3 3779127                     404 Barbadoes St
       Fax:   +64 3 3779135                     PO Box 13 889
       Email: ryan@bluewatersys.com             Christchurch, 8013
       Web:   http://www.bluewatersys.com       New Zealand
       Freecall Australia  1800 148 751         USA 1800 261 2934
