Return-Path: <linux-kernel-owner+w=401wt.eu-S1030538AbXBFXKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030538AbXBFXKh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 18:10:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030551AbXBFXKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 18:10:37 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:29279 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030538AbXBFXKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 18:10:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=KPcCefRvUK7IlceEq7ron2jxZuoRo94dWwsBZSs0ifixMyKWACHKvj5SvtLhTXPP+rF/IogkHLq6x0oSN4f2TR1HI77emZOP+eS4uNqC1aDg2ctePfphUPlJB5oZBiIjHVj/ChGX78EbmXdoLHS3nOWqjNnaMJReqFieNE/jwj4=
Message-ID: <45C90C1A.6090906@gmail.com>
Date: Wed, 07 Feb 2007 00:15:38 +0100
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>
CC: Alan <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, Trent Waddington <trent.waddington@gmail.com>
Subject: Re: [PATCH][0/5] floppy.c: first round of cleanup patches - the simple
 stuff
References: <200702060028.31691.jesper.juhl@gmail.com>	 <20070206114152.4b622e40@localhost.localdomain> <58cb370e0702061458u41f0a108n1eeae03770433bbf@mail.gmail.com>
In-Reply-To: <58cb370e0702061458u41f0a108n1eeae03770433bbf@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Alan wrote:
> 
> On Tue, 6 Feb 2007 00:28:31 +0100
> Jesper Juhl <jesper.juhl@gmail.com> wrote:
> 
>> Greetings people,
>>
>> Here is, as promised, the first round of cleanup patches for floppy.c
>> (more will follow later).
>>
>> I opted to start with the simple stuff first, both to get it out of
>> the way
>> and also to get something done resonably fast, so don't expect anything
>> earth shattering in this first series.
>>
>> There are 5 patches in this series. They are based on 2.6.20 and are
>> incremental.
>>
>> These are the patches (they'll be posted to the same recipients as
>> this initial mail) :
>>
>>       [PATCH][1/5] floppy.c: Initial (partial) CodingStyle cleanup
>>       [PATCH][2/5] floppy.c: Remove pointless register keywords
>>       [PATCH][3/5] floppy.c: Remove dead/commented out code
>>       [PATCH][4/5] floppy.c: Add explicit/better printk() levels
>>       [PATCH][5/5] floppy.c: Fix device_create_file() warning
> 
> Acked-by: Alan Cox <alan@redhat.com>
> 
> for the set of 5 patches. Its a beginning and removing the dead wood so
> you can see what is actually there is a good a beginning as any other.

Seconded, looks like a good beginning.
You may also add my ACK for the whole set.

Thanks,
Bart

