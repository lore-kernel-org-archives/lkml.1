Return-Path: <linux-kernel-owner+w=401wt.eu-S1753663Ab0AJQt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab0AJQt6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 11:49:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753481Ab0AJQt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 11:49:57 -0500
Received: from blu0-omc1-s31.blu0.hotmail.com ([65.55.116.42]:23905 "EHLO
	blu0-omc1-s31.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753436Ab0AJQt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 11:49:56 -0500
X-Originating-IP: [88.139.71.92]
X-Originating-Email: [megastorage@hotmail.fr]
Message-ID: <BLU0-SMTP405DCDD7C964BB7E79723BCD6E0@phx.gbl>
Date: Sun, 10 Jan 2010 17:48:48 +0100
From: Megastorage <megastorage@hotmail.fr>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org
Subject: [Fwd: Re: System stop with kernel 2.6.32.2 and kernel-linus 2.6.33.0-rc2//rc3]
Content-Type: multipart/mixed;
 boundary="------------070206040607090401010907"
X-OriginalArrivalTime: 10 Jan 2010 16:49:55.0928 (UTC) FILETIME=[F0229580:01CA9214]
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070206040607090401010907
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



--------------070206040607090401010907
Content-Type: message/rfc822;
 name="Re: System stop with kernel 2.6.32.2 and kernel-linus 2.6.33.0-rc2//rc3.eml"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename*0="Re: System stop with kernel 2.6.32.2 and kernel-linus 2.6.33";
 filename*1=".0-rc2//rc3.eml"

X-Mozilla-Keys: 
Message-ID: <4B4A0386.5070101@hotmail.fr>
Date: Sun, 10 Jan 2010 17:42:46 +0100
From: Megastorage <megastorage@hotmail.fr>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Michael Breuer <mbreuer@majjas.com>
Subject: Re: System stop with kernel 2.6.32.2 and kernel-linus 2.6.33.0-rc2//rc3
References: <4B3E1BF4.2090005@hotmail.fr> <BLU0-SMTP71AE1AC6DF8DA389599B0DCD6E0@phx.gbl> <4B4A000E.4060103@majjas.com>
In-Reply-To: <4B4A000E.4060103@majjas.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Normaly yes, the raid module is loaded.

On this screen: 
https://bzattachment.mandriva.com/attachment.cgi?id=16312  you can read:
Raid set: "*******" was activated

And after I have:
http://img515.imageshack.us/i/dscf2871.jpg/

Stef.


Michael Breuer a écrit :
> Silly question, do you have the raid module loaded? I hit the same 
> thing a while back as mkinitrd didn't properly include the raid456 
> driver into initrd. I'd go back to the working system, do an lsmod see 
> what's running, then check the initrd for the failed system and make 
> sure you've got all the pieces.
> On 1/10/2010 10:57 AM, Megastorage wrote:
>> I'm testing with the kernel 2.6.33 RC3, same problem.
>>
>> Stef.
>>
>> Megastorage a écrit :
>>> Dear all,
>>>
>>> Sorry for my english, I'm french and I'm not an expert to report a bug.
>>>
>>> I working with Mandriva cooker.
>>>
>>> My system can start on kernel 2.6.31.6 whitout problem.
>>>
>>> If  I start on  the kernel  2.6.32.2, my system stop on this screen:
>>> http://img198.imageshack.us/img198/416/dscf2869k.jpg
>>> http://img24.imageshack.us/img24/9079/dscf2870.jpg
>>>
>>> I'm testing with the kernel-linus 2.6.33.0-RC2 faults to:
>>> http://img515.imageshack.us/i/dscf2871.jpg/
>>>
>>>
>>> My fstab:
>>> http://en.pastebin.ca/1734080
>>>
>>> My hardware configuration:
>>> Asus A8N-sli deluxe
>>> Raid system on the chipset nvidia and Silicon image.
>>>
>>>
>>> If you need more information. You can ask me.
>>>
>>> Thanks for your help.
>>> Stephane.
>>>
>>>
>>>
>>>
>>>
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>



--------------070206040607090401010907--
