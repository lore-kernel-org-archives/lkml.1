Return-Path: <linux-kernel-owner+w=401wt.eu-S1758866AbYEFMPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758866AbYEFMPO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 08:15:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbYEFMPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 08:15:00 -0400
Received: from elasmtp-mealy.atl.sa.earthlink.net ([209.86.89.69]:41341 "EHLO
	elasmtp-mealy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752859AbYEFMO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 08:14:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=ZeSOKwzJLklNHhCWoSkJNv2aRAahkHG2K4jtSMVVG6gRH3gO6LSyVydo61acjO/T;
  h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <48204BC1.4090903@earthlink.net>
Date: Tue, 06 May 2008 08:14:57 -0400
From: Stephen Clark <sclark46@earthlink.net>
Reply-To: sclark46@earthlink.net
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Wim Van Sebroeck <wim@iguana.be>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: iTCO watchdog timer
References: <47CDAC9D.6020505@seclark.us> <20080304135548.b7b88ee4.akpm@linux-foundation.org> <20080306212820.GA2866@infomag.infomag.iguana.be> <47EBE751.1090803@earthlink.net> <20080327183437.GA15490@infomag.infomag.iguana.be> <47EBEE68.1020901@earthlink.net> <20080327205414.GB15490@infomag.infomag.iguana.be> <47ECF996.6020600@earthlink.net>
In-Reply-To: <47ECF996.6020600@earthlink.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-ELNK-Trace: a437fbc6971e80f61aa676d7e74259b7b3291a7d08dfec793ccf9d646b96d12e88ef198ae1a11aaf350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 24.144.77.185
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Clark wrote:
> Wim Van Sebroeck wrote:
>> Hi Steve,
>>
>>> [root@joker20 ~]# ./testwdog
>>> The GETSUPPORT call reported (-1):
>>>   options         : ?
>>>   firmware_version: ?
>>>   identity        : ?
>>> The GETSTATUS call reported 0 (0)
>>> The GETBOOTSTATUS call reported 0 (0)
>>> The GETTEMP call reported 0°F = -17°C (ret=-1)
>>> The SETOPTIONS (DISABLECARD) call returned=0
>>> The SETOPTIONS (ENABLECARD) call returned=0
>>> The timeout is 30 seconds (0)
>>> The timeout is now set to 34 seconds (0)
>>> The timeout is 34 seconds (0)
>>> The GETTIMELEFT call reported 33 seconds (0x0021) (0)
>>> The GETTIMELEFT call reported 19 seconds (0x0013) (0)
>>> The GETTIMELEFT call reported 20 seconds (0x0014) (0)
>>> The GETTIMELEFT call reported 21 seconds (0x0015) (0)
>>> The GETTIMELEFT call reported 22 seconds (0x0016) (0)
>>> The GETTIMELEFT call reported 22 seconds (0x0016) (0)
>>
>> So the timer counts down. So I have to find out why it doesn't reboot.
>> And it has to do only with the ICH9 chipsets. I'll adapt the iTCO_wdt
>> driver so that we have extra debugging info and will sent it to you.
>>
>> Greetings,
>> Wim.
>>
> Thanks,
> 
> I'll be waiting patiently.
> 
> Regards,
> Steve
> 
Hi Wim,

Still waiting.

Regards,
Steve
-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)


