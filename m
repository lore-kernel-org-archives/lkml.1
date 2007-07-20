Return-Path: <linux-kernel-owner+w=401wt.eu-S935627AbXGTRJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935627AbXGTRJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 13:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932429AbXGTRIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 13:08:45 -0400
Received: from mail.atmel.fr ([81.80.104.162]:45783 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765792AbXGTRIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 13:08:39 -0400
Message-ID: <46A0D3A2.5000703@rfo.atmel.com>
Date: Fri, 20 Jul 2007 17:24:18 +0200
From: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Organization: atmel
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
CC: Pierre Savary <pierre.savary@kerlink.fr>, s@drzeus.cx,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: TR: Neep help with my MMC driver ...
References: <000c01c7cad4$127dcba0$377962e0$@savary@kerlink.fr> <20070720160036.581f8fba@poseidon.drzeus.cx>
In-Reply-To: <20070720160036.581f8fba@poseidon.drzeus.cx>
Content-Type: text/plain;
	charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: 7bit
X-ESAFE-STATUS: Mail clean
X-ESAFE-DETAILS: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman :
> On Fri, 20 Jul 2007 15:44:18 +0200
> "Pierre Savary" <pierre.savary@kerlink.fr> wrote:
> 
>> Hi,
>>
>>  
>>
>> I permit me to send you a mail because I've seen on the net that you
>> have work around MMC.
> 
> Well, I am the maintainer ;)
> 
> Also, you should include the LKML for these discussions.
> 
>> Linux 2.6.21+patch.AT91 run on my AT91sam9260. I must use the MMC.
>> But it doesn't work . and I try since the begin of this week !!!!!!!!
>> This is what I do :

Please use the very last patchset developed those last days for at91_mci.

Regards,
-- 
Nicolas Ferre


