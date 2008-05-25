Return-Path: <linux-kernel-owner+w=401wt.eu-S1753628AbYEYOXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628AbYEYOXE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 10:23:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbYEYOWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 10:22:51 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:47412 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755421AbYEYOWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 10:22:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=j6/Thyp4VwuB5GV2fibumpAK0Oh4K4w5I94TS0ZgHhOhKx10CFlS3x6XmkrxaArpf6r+hx4Nnwyp77Tkstf+LVIYpTCY7qupLj0F5pgXkl17DJdc5HR7YVnXbb6FTY9uJHpvtlwWKxubBCSh1MSHh9toHTfWwZkD5v2wHIFfTWo=
Message-ID: <7b9198260805250722m5ccecf8by28fefac052edac97@mail.gmail.com>
Date: Sun, 25 May 2008 15:22:49 +0100
From: "Tom Spink" <tspink@gmail.com>
To: "Gene Heskett" <gene.heskett@verizon.net>
Subject: Re: Something odd in knail from 3.5.9 on F8
Cc: kdepim-users@kde.org, linux-kernel@vger.kernel.org
In-Reply-To: <200805250922.15059.gene.heskett@verizon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805250750.31491.gene.heskett@verizon.net>
	 <7b9198260805250608i3b30d0ccg2dcb818c202b8e22@mail.gmail.com>
	 <200805250922.15059.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/25 Gene Heskett <gene.heskett@verizon.net>:
> On Sunday 25 May 2008, Tom Spink wrote:
>>2008/5/25 Gene Heskett <gene.heskett@verizon.net>:
>>> Greetings all;
>>>
>>> Yesterday I needed to email a patch file I had just generated to the
>>> maintainer of the OS for a "legacy" computer, so I fired up the new mail
>>> by clicking on his name in a previous email, wrote a short msg and tried
>>> to attach the patch. But regardless of how many times I backed out of the
>>> directory & then went back in, the directory listing I was being shown was
>>> exactly as it had existed about 36 hours ago.  No new files could be seen.
>>>  So I could not attach it, nor include it as text in that msg.
>>> .
>>> After I had sent the msg, I shut kmail down using its quit button, gave it
>>> 30 secs to clean up and disappear from the htop list, then restarted it,
>>> at which point the newer and missing files were then visible and I sent
>>> the patch using the exact same procedure.
>>>
>>> Currently running locally built 2.6.26-rc2 for a kernel.  So which
>>> direction do I point the accusatory finger here folks?
>>
>>Hi Gene,
>>
>>Are you able to reproduce the problem?  Were you able to view the
>>"real" contents of the directory in, say, a terminal (with ls) or
>>Konqueror (or whatever you prefer), while KMail was acting up?
>>
> Yes, ls or ls -l displayed them correctly in several other terminal shells,
> while kmail couldn't see them.  But, kmail had not looked at that directory
> since launching it at the last bootup till then, so I can't quite bring myself
> to believe it was looking at old cached info, that was its first look there
> since bootup a day before.
>
> And now of course it works.  Same kernel, same kmail.  Go figure, but I think it
> will take some of that new-fangled math to make 2+2=4 in this case. :-\

Heh, cool.  I guess it's some weird "KDE-caching" Heisenbug.  Although
I'm no KDE expert at all, and don't know how their file browsers work.

> Thanks Tom.

No problem.

> Cheers, Gene

-- 
Tom Spink
