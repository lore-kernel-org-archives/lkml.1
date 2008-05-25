Return-Path: <linux-kernel-owner+w=401wt.eu-S1754077AbYEYNX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbYEYNX0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 09:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753541AbYEYNWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 09:22:54 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:45674 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755942AbYEYNWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 09:22:53 -0400
Date: Sun, 25 May 2008 09:22:14 -0400
From: Gene Heskett <gene.heskett@verizon.net>
Subject: Re: Something odd in knail from 3.5.9 on F8
In-reply-to: <7b9198260805250608i3b30d0ccg2dcb818c202b8e22@mail.gmail.com>
To: "Tom Spink" <tspink@gmail.com>
Cc: kdepim-users@kde.org, linux-kernel@vger.kernel.org
Message-id: <200805250922.15059.gene.heskett@verizon.net>
Organization: Organization? Not detectable
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200805250750.31491.gene.heskett@verizon.net>
 <7b9198260805250608i3b30d0ccg2dcb818c202b8e22@mail.gmail.com>
User-Agent: KMail/1.9.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 25 May 2008, Tom Spink wrote:
>2008/5/25 Gene Heskett <gene.heskett@verizon.net>:
>> Greetings all;
>>
>> Yesterday I needed to email a patch file I had just generated to the
>> maintainer of the OS for a "legacy" computer, so I fired up the new mail
>> by clicking on his name in a previous email, wrote a short msg and tried
>> to attach the patch. But regardless of how many times I backed out of the
>> directory & then went back in, the directory listing I was being shown was
>> exactly as it had existed about 36 hours ago.  No new files could be seen.
>>  So I could not attach it, nor include it as text in that msg.
>> .
>> After I had sent the msg, I shut kmail down using its quit button, gave it
>> 30 secs to clean up and disappear from the htop list, then restarted it,
>> at which point the newer and missing files were then visible and I sent
>> the patch using the exact same procedure.
>>
>> Currently running locally built 2.6.26-rc2 for a kernel.  So which
>> direction do I point the accusatory finger here folks?
>
>Hi Gene,
>
>Are you able to reproduce the problem?  Were you able to view the
>"real" contents of the directory in, say, a terminal (with ls) or
>Konqueror (or whatever you prefer), while KMail was acting up?
>
Yes, ls or ls -l displayed them correctly in several other terminal shells, 
while kmail couldn't see them.  But, kmail had not looked at that directory 
since launching it at the last bootup till then, so I can't quite bring myself 
to believe it was looking at old cached info, that was its first look there 
since bootup a day before.

And now of course it works.  Same kernel, same kmail.  Go figure, but I think it 
will take some of that new-fangled math to make 2+2=4 in this case. :-\

Thanks Tom.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
The earth is like a tiny grain of sand, only much, much heavier.
