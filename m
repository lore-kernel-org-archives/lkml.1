Return-Path: <linux-kernel-owner+w=401wt.eu-S932417AbZACQwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932417AbZACQwo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 11:52:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758339AbZACQwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 11:52:35 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:27062 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758019AbZACQwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 11:52:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:x-mailer:mime-version:subject:date:cc;
        b=Mh0CGMovmdKtSgTfbWOsX8jHUkNSvBjwBU8zFJyI4M9lM81RoxhL5CupZetgPYZoql
         5GkV/xcCn2dqr1cpgFPcG5R3hB9vrTjucrLArQotkWO2FwFaB/niWzc+bY0HgDEKm8Rp
         D1XmRXy6PmDa/UlZZhv4RiJ22HkuOc9FCVLTc=
References: <495ED1C4.8020304@gmail.com> <20090103032134.GA20209@redhat.com> <495EDC10.20605@gmail.com> <f488382f0901021949y60b6d60fjeaeb6bb12a851f8@mail.gmail.com> <495EE2A0.2080703@gmail.com> <495EEE1D.8050500@shaw.ca> <20090103073051.GC5038@1wt.eu> <195c7a900901030615i19dc95afyab22390fe867e09d@mail.gmail.com>
Message-Id: <C1E66375-7D46-4923-96AA-194155D1912E@gmail.com>
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: Bastien ROUCARIES <roucaries.bastien@gmail.com>
In-Reply-To: <195c7a900901030615i19dc95afyab22390fe867e09d@mail.gmail.com>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (5G77)
Mime-Version: 1.0 (iPhone Mail 5G77)
Subject: Re: ath9k microwave anomaly
Date: Sat, 3 Jan 2009 08:52:22 -0800
Cc: Willy Tarreau <w@1wt.eu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks..
I'll have to look at that and see.
In any case, I still am amazed at how that little box was able to  
cause the
Wireless to timeout like it did, especially with the distance apart  
they are. Scary but amazing, and also an answer to one of my problems  
with wireless I had for a while. :^)

justin P. Mattock



On Jan 3, 2009, at 6:15 AM, "Bastien ROUCARIES" <roucaries.bastien@gmail.com 
 > wrote:

>>
>> BTW, having any WiFi stopping working at 30 feet around a microwave  
>> oven
>> makes me think that beast is leaking like mad. I've already ran  
>> experiences
>> with mine in the past, and it could only slightly perturbate the  
>> traffic
>> within one meter (3 ft) which I already considered huge. You may  
>> want to
>> try to put some aluminium foil on the front door, it is possible  
>> that the
>> protection grid is damaged or not properly sealed.
>
> Likely not the grid. The grid is pretty solid. I will guess it is the
> wave traps seals arround the microwave door (often they are made
> rubber part mixed with conductive stuff) that are too old. These seals
> tend to expand when hot and are therefore more efficient. You could
> change it for cheap ($10), ask our local general store. As a quick fix
> (not recommended) you could add some electrical conductive grease but
> it will further decreade long term abilty of these seals (grease tend
> to crack rubber), and these kind of grease are not really food
> compatible.
>
> Bastien
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
