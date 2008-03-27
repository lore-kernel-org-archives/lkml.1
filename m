Return-Path: <linux-kernel-owner+w=401wt.eu-S1756448AbYC0S2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448AbYC0S2r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 14:28:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750984AbYC0S2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 14:28:38 -0400
Received: from elasmtp-kukur.atl.sa.earthlink.net ([209.86.89.65]:39437 "EHLO
	elasmtp-kukur.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751150AbYC0S2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 14:28:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=O+pJnBsJD9KERsB1+yOyL9HFLOTqOJv0kI1luirVfoAqEaeS7GHT0L4xrdVrTeTX;
  h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <47EBE751.1090803@earthlink.net>
Date: Thu, 27 Mar 2008 14:28:33 -0400
From: Stephen Clark <sclark46@earthlink.net>
Reply-To: sclark46@earthlink.net
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Wim Van Sebroeck <wim@iguana.be>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: iTCO watchdog timer
References: <47CDAC9D.6020505@seclark.us> <20080304135548.b7b88ee4.akpm@linux-foundation.org> <20080306212820.GA2866@infomag.infomag.iguana.be>
In-Reply-To: <20080306212820.GA2866@infomag.infomag.iguana.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: a437fbc6971e80f61aa676d7e74259b7b3291a7d08dfec79efd0c272ce40aac2c02594fa4023b4bb350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 24.144.77.185
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wim Van Sebroeck wrote:
> Hi All,
> 
> Sorry but it's quite busy at the moment...
> 
>>> I have new Intel DG33FB mainboard.
>>>
>>>
>>> Mar  2 20:47:19 joker1 kernel: iTCO_vendor_support: vendor-support=0
>>> Mar  2 20:47:19 joker1 kernel: iTCO_wdt: Intel TCO WatchDog Timer Driver 
>>> v1.02 (26-Jul-2007)
>>> Mar  2 20:47:19 joker1 kernel: iTCO_wdt: Found a ICH9DH TCO device 
>>> (Version=2, TCOBASE=0x0460)
>>> Mar  2 20:47:19 joker1 kernel: iTCO_wdt: initialized. heartbeat=30 sec 
>>> (nowayout=0)
>>> ...
>>> Mar  4 14:22:59 joker1 kernel: iTCO_wdt: Unexpected close, not stopping 
>>> watchdog!
>>>
>>>
>>> I start watchdog.c and then kill it expecting the system to reboot - but 
>>> it doesn't.
>>>
>>> Isn't this how it is supposed to work?
> 
> This is indeed how it should work. It's indeed strange that the system doesn't
> reboot. If I find some time I will give you some test code to run.
> 
> Greetings,
> Wim.
> 
> 

Hi Wim,

Just wondered if you had any more thoughts or if you have any test you 
would like me to run.

Regards,
Steve

-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)


