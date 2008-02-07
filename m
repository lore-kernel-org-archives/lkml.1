Return-Path: <linux-kernel-owner+w=401wt.eu-S1759108AbYBGPkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759108AbYBGPkJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 10:40:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757249AbYBGPjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 10:39:55 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:34922 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756579AbYBGPjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 10:39:54 -0500
Message-ID: <47AB2647.4090000@davidnewall.com>
Date: Fri, 08 Feb 2008 02:09:51 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Marcel Holtmann <marcel@holtmann.org>, Greg KH <greg@kroah.com>,
       Christer Weinigel <christer@weinigel.se>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
References: <20080125180232.GA4613@kroah.com>	<20080202123710.42df1aa0@weinigel.se>	<20080202191930.GA19826@kroah.com>	<47A5D9CD.5070001@davidnewall.com>	<84144f020802030743j1278ac64j2ee3e2cbc5c3fefc@mail.gmail.com>	<47A5E67D.9040804@davidnewall.com>	<1202058820.15090.60.camel@violet>	<courier.47A84ADB.000047C1@hawking.rebel.net.au>	<1202241819.15090.133.camel@violet>	<47AB0B67.7060103@davidnewall.com> <20080207142812.0dafde98@core>
In-Reply-To: <20080207142812.0dafde98@core>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> It's nonsense, it's a reasonable reading of the GPL.  What I am doing is
>> telling you what the GPL says, not what you wish it said.
>>     
>
> In which case for each statement please give the case at appeal or higher
> level which is the precedent for the interpretation.
>   

I am giving my opinion.  By contrast, you have claimed to be giving the
opinion of numerous lawyers.  I hate to be so blunt, but that is the
naked truth.  You could improve that situation.


>>> If the developers say that this symbol can only be used in GPL code (and
>>> with EXPORT_SYMBOL_GPL it is quite clear) then you have to obey to that
>>> license or don't use this symbol at all.
>>>   
>>>       
>> EXPORT_SYMBOL_GPL is not a licence.  Only a licence is a licence.
>>     
>
> Export symbol is a guide. There is no reason to think that EXPORT_SYMBOL
> symbols alone mean your work is somehow not derivative.

No argument, other than with, "export symbol is a guide."   My argument
with that is that one could mistakenly infer that "export symbol"
includes "EXPORT_SYMBOL_GPL."   The latter is not a guide, is it?  It
restricts a symbol from use by proprietary modules.
