Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbYI3Mrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbYI3Mrc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 08:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753115AbYI3MrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 08:47:14 -0400
Received: from ns.netcenter.hu ([195.228.254.57]:50359 "EHLO netcenter.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753023AbYI3MrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 08:47:13 -0400
Message-ID: <3c5701c922f5$a2caee70$0400a8c0@dcccs>
From: "Janos Haar" <janos.haar@netcenter.hu>
To: "Ray Lee" <ray-lk@madrabbit.org>
Cc: <linux-kernel@vger.kernel.org>
References: <2e8201c91fba$1befac80$0400a8c0@dcccs> <2c0942db0809261412l23424ad0o96a117bce87472dc@mail.gmail.com>
Subject: Re: Whats going on? (somebody can say something?)
Date: Tue, 30 Sep 2008 14:06:03 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="UTF-8";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3350
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Original Message ----- 
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Janos Haar" <djani22@netcenter.hu>
Cc: <linux-kernel@vger.kernel.org>
Sent: Friday, September 26, 2008 11:12 PM
Subject: Re: Whats going on? (somebody can say something?)


> On Fri, Sep 26, 2008 at 2:27 AM, Janos Haar <djani22@netcenter.hu> wrote:
>> Hello list,
>>
>> Good day for everibody.
>>
>> I have one problem with my new linux box. (again)
>> The hw is tested. (memtest86, 4 days)
>>
>> The samba freezed and makes 40 load.
>>
>> All what i am using is in-kernel solution, excepting samba.
>>
>> libata ->bock -> raid -> cryptoloop -> xfs -> [samba] ->eth
>
> That's pretty much guaranteed to crash if you're using 4k stacks. Are you?

No. :-)
I know this.

>
>> The log file is here:
>> http://download.netcenter.hu/bughunt/20080925/messages
>
> You have oopses in that log, but didn't mention them in your email or
> include them within. Please read the reporting bugs document in the
> kernel tree to see a better way to get the attention of those who
> should be looking at your problem.
>
> Good luck.

Thank you.
If i will have a little time, i will do that....

Thanks,
Janos Haar 

