Return-Path: <linux-kernel-owner+w=401wt.eu-S1759373AbYBGMlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759373AbYBGMlx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 07:41:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755950AbYBGMlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 07:41:44 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:34756 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025AbYBGMln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 07:41:43 -0500
Message-ID: <47AAFC80.1050700@davidnewall.com>
Date: Thu, 07 Feb 2008 23:11:36 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: Chris Friesen <cfriesen@nortel.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Greg KH <greg@kroah.com>, Christer Weinigel <christer@weinigel.se>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
References: <20080125180232.GA4613@kroah.com>	 <20080202123710.42df1aa0@weinigel.se> <20080202191930.GA19826@kroah.com>	 <47A5D9CD.5070001@davidnewall.com>	 <84144f020802030743j1278ac64j2ee3e2cbc5c3fefc@mail.gmail.com>	 <47A5E67D.9040804@davidnewall.com> <1202058820.15090.60.camel@violet>	 <courier.47A84ADB.000047C1@hawking.rebel.net.au>	 <1202241819.15090.133.camel@violet>  <47A8C893.6000103@nortel.com> <1202245958.15090.145.camel@violet>
In-Reply-To: <1202245958.15090.145.camel@violet>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcel Holtmann wrote:
>>> If the developers say that this symbol can only be used in GPL code (and
>>> with EXPORT_SYMBOL_GPL it is quite clear) then you have to obey to that
>>> license or don't use this symbol at all.
>>>       
Not sure who wrote the above, but it contains a glaring legal error:
Developers choose an invalid forum to impose licence conditions when
they choose to do so via EXPORT_SYMBOL_GPL.  The licence that prevails
is GPL, and nowhere does it say that protected works may only be used by
other GPL works.  In fact, such a notion is alien to the GPL.


>>> If you use that symbol inside non-GPL (meaning you link at runtime) then
>>> you are in violation of the GPL license. We can't make it much clearer.
>>>       
>> Not necessarily so.  The developers feel that any code using that symbol 
>> is necessarily a derivative work, but at the end of the day it would be 
>> up to the legal system to decide whether it really is or not.
>>     
Of course courts are the proper forum to decide "fact" from opinion, but
a statement of claim, which is a necessary preliminary to such an
action, must state from what the alleged offending work is derived.  The
fact that claim of violation is made before any violating work has been
identified, or even created, does work against such an action.  A 
half-decent lawyer should be able to have any such action dismissed on
that basis alone.

I wonder if it isn't fraud to offer a work under the GPL and then to try
to impose new conditions.
