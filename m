Return-Path: <linux-kernel-owner+w=401wt.eu-S1758504AbZLNWAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758504AbZLNWAY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 17:00:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758398AbZLNWAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 17:00:24 -0500
Received: from host013.keli.cz ([77.48.235.13]:37526 "EHLO host013.keli.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758239AbZLNWAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 17:00:21 -0500
Message-ID: <4B26B55B.8010302@titera.eu>
Date: Mon, 14 Dec 2009 22:59:55 +0100
From: =?ISO-8859-2?Q?Petr_Tit=ECra?= <petr@titera.eu>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: Wrong atime on recent kernels
References: <4B26AB7E.9020208@titera.eu> <87d42hxmgd.fsf@basil.nowhere.org>
In-Reply-To: <87d42hxmgd.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen napsal(a):
> Petr Titìra <petr@titera.eu> writes:
>
>   
>> Hello,
>>
>>       I see some strange file modification times recently. It seems to
>> me that in some situations, kernel allows to set nanoseconds part of
>> file access, modification or change time  to 100000000 ns. Problem
>> seems to be in some generic part of kernel because I see it on several
>> different filesysytems (ext4 and nilf2). These is I've got during my
>> testing on kernel  2.6.32-tip-08309-gad8e75a.
>>     
>
> Do you know which kernel was the last one to be not showing this?
>
>   
To Be honest I'm not sure. I remember that I've seen it for the first
time when I tried to install kernel-2.6.32-0.65.rc8.git5.fc13.i686
package from Fedora Rawhide and that was on 7th December. The only
kernels I could be running at that time are:
2.6.32-rc8-tip-02151-gf00b740, 2.6.32-tip-02531-gbbbe9f2 or
2.6.32-tip-02695-g4dc2ffc.

> Is 2.6.32 plain ok?
>
>   
Will test.

> -Andi
>
>   

Petr

