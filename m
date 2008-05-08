Return-Path: <linux-kernel-owner+w=401wt.eu-S1760127AbYEHHIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760127AbYEHHIz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 03:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753174AbYEHHIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 03:08:44 -0400
Received: from smtp1.tech.numericable.fr ([82.216.111.37]:38084 "EHLO
	smtp1.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbYEHHIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 03:08:44 -0400
Message-ID: <4822A6F7.7010704@numericable.fr>
Date: Thu, 08 May 2008 09:08:39 +0200
From: Rufus & Azrael <rufus-azrael@numericable.fr>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
CC: Ingo Molnar <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.25-git18 => 2.6.26-rc1-git1] Xorg crash with	xf86MapVidMem
 error
References: <481D72A7.10901@numericable.fr> <20080504085204.GE21859@elte.hu> <481D7BF8.4080405@numericable.fr> <20080505172619.GD28173@linux-os.sc.intel.com> <481F87F2.70005@numericable.fr> <20080505232536.GA28026@linux-os.sc.intel.com> <20080505234938.GB11433@elte.hu> <20080506020910.GA24041@linux-os.sc.intel.com> <20080506115524.GE32591@elte.hu> <4820962B.6050702@numericable.fr> <924EFEDD5F540B4284297C4DC59F3DEE01004FC1@orsmsx423.amr.corp.intel.com> <4820D415.5090900@numericable.fr> <924EFEDD5F540B4284297C4DC59F3DEE010050B6@orsmsx423.amr.corp.intel.com> <482217F3.2040900@numericable.fr> <924EFEDD5F540B4284297C4DC59F3DEE010057B4@orsmsx423.amr.corp.intel.com>
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEE010057B4@orsmsx423.amr.corp.intel.com>
Content-Type: multipart/mixed;
 boundary="------------080601040701060609040000"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080601040701060609040000
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: quoted-printable

Pallipadi, Venkatesh a =E9crit :
> =20
>
>  =20
>> -----Original Message-----
>> From: Rufus & Azrael [mailto:rufus-azrael@numericable.fr]=20
>> Sent: Wednesday, May 07, 2008 1:58 PM
>> To: Pallipadi, Venkatesh
>> Cc: Ingo Molnar; Siddha, Suresh B; Linux-kernel Mailing List
>> Subject: Re: [2.6.25-git18 =3D> 2.6.26-rc1-git1] Xorg crash with=20
>> xf86MapVidMem error
>>
>> Pallipadi, Venkatesh a =E9crit :
>>    =20
>>> =20
>>>
>>> Yes. This has some debug information in there. Did you see=20
>>>      =20
>> xf86MapVidMem error (I mean did you try to start X) before you=20
>> captured this dmesg?
>>    =20
>>> Thanks,
>>> Venki
>>>
>>>  =20
>>>      =20
>> Hi all,
>>
>> Yes, the error's message is in my Xorg.log file :-)
>>
>>    =20
>
> One more piece of data I need. Can you please send the output of `cat /=
proc/mtrr` from this system (after the X failure has happened)
>
> Thanks,
> Venki
>
>  =20
Hi Venki,


See my /proc/mtrr file attached.

Regards.

--------------080601040701060609040000
Content-Type: text/plain;
 name="mtrr"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mtrr"

reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
reg01: base=0xf0000000 (3840MB), size=  16MB: write-combining, count=1

--------------080601040701060609040000--
