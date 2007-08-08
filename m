Return-Path: <linux-kernel-owner+w=401wt.eu-S1759250AbXHHV7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759250AbXHHV7V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 17:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752719AbXHHV7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 17:59:13 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:49473
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbXHHV7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 17:59:12 -0400
Message-ID: <46BA4A48.8060002@microgate.com>
Date: Wed, 08 Aug 2007 16:57:12 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 55] drivers/char/n_hdlc.c: kmalloc + memset conversion
 to kzalloc
References: <200707311845.48807.m.kozlowski@tuxland.pl>	<200707312327.30692.m.kozlowski@tuxland.pl>	<20070801011655.08e3c17b@the-village.bc.nu>	<200708080802.24635.m.kozlowski@tuxland.pl> <m3d4xx66xv.fsf@maximus.localdomain>
In-Reply-To: <m3d4xx66xv.fsf@maximus.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> Mariusz Kozlowski <m.kozlowski@tuxland.pl> writes:
> 
>> Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
>>
>>  drivers/char/n_hdlc.c | 27451 -> 27413 (-38 bytes)
>>  drivers/char/n_hdlc.o | 107068 -> 107088 (+20 bytes)
> 
> BTW: drivers/char/n_hdlc is a very different thing than these
> in drivers/net/wan/ and I have no connection with it. Not sure
> who is responsible, if anyone.

I am, my email is at the top of n_hdlc.c but there
is no maintainers entry.

--
Paul Fulghum
Microgate Systems, Ltd

