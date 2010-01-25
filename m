Return-Path: <linux-kernel-owner+w=401wt.eu-S1753742Ab0AYOxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab0AYOxJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 09:53:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260Ab0AYOxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 09:53:07 -0500
Received: from mail-iw0-f173.google.com ([209.85.223.173]:61209 "EHLO
	mail-iw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab0AYOxG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 09:53:06 -0500
X-Greylist: delayed 497 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Jan 2010 09:53:06 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=jznADvimAlv0QbfQpS6YjjP8vi1TiCCviGxk1fXG/DQmXY4SJyGYiw6F0Nmab3nDSg
         7rRkGvSfmrN3zZXj96EMPzcLBYjUkjms4iAc1nyv/KnoGhkfat5As2Wl/7CYi3n7MPOx
         goz5t54NTAMBae7dxJ7pc78BriPpXhGICwJGw=
MIME-Version: 1.0
In-Reply-To: <84144f021001250610q3160ea06tac5f645b84285388@mail.gmail.com>
References: <pYFNu11z2aM.A.pJH.CZMXLB@chimera> <q60Z28d_9yH.A.70H.SZMXLB@chimera> 
	<84144f021001250610q3160ea06tac5f645b84285388@mail.gmail.com>
From: Manish Katiyar <mkatiyar@gmail.com>
Date: Mon, 25 Jan 2010 20:14:28 +0530
Message-ID: <ea11fea31001250644i78a9e4d9q725eb04f6a7da164@mail.gmail.com>
Subject: Re: [Bug #15015] blank screen at random times in laptop when sitting 
	idle
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jithin Emmanuel <jithin1987@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 25, 2010 at 7:40 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> On Mon, Jan 25, 2010 at 12:23 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> This message has been generated automatically as a part of a report
>> of regressions introduced between 2.6.31 and 2.6.32.
>>
>> The following bug entry is on the current list of known regressions
>> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
>> be listed and let me know (either way).
>>
>>
>> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=15015
>> Subject         : blank screen at random times in laptop when sitting idle
>> Submitter       : Jithin Emmanuel <jithin1987@gmail.com>
>> Date            : 2010-01-09 16:48 (16 days old)
>
> FWIW, I might have seen this on my Macbook as well (screen went blank
> but I didn't check the logs). I think I managed to unblank the screen
> by hitting the "increase brightness" key. But as you say, the bug
> doesn't trigger very often and I have no idea how to reproduce it at
> will.

I have seen it too on my lenovo T60 with 2.6.32.2. It happens to me
frequently and has become famous as "coffee bug" in my colleagues.
Every morning when I goto office and after putting my laptop on
docking station go for coffee. Once I come back the laptop screen goes
blank, but haven't been able to manage how to get screen back. Only
option is hard reboot. This happens almost every once in two three
days.

Let me know what information/logs I can provide to help debug this.
BTW I normally suspend my laptop at home and then resume it in office
(if that matters).



>
>                         Pekka
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-testers" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Thanks -
Manish
==================================
[$\*.^ -- I miss being one of them
==================================
