Return-Path: <linux-kernel-owner+w=401wt.eu-S1753560AbZAKViT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560AbZAKViT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 16:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751290AbZAKViL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 16:38:11 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:22727 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbZAKViK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 16:38:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=IjjoS8gKk2VRClVaSUJhRVIGocf0b/h0znHLf4vwZheY0p+1m7b69vhewuxPti+OtV
         M+4D09LbMtQ/MPYuM2gvQVwzT8Oi0VrMvwCWxjkajWBiXgmyuWma8oKyr9lHq/izPSdq
         7r4fQVqUM7tgc5PzJk5W1pN5jWEMqjBlAssqQ=
Message-ID: <8db1092f0901111338j5906c22csd75fa9070fe195a3@mail.gmail.com>
Date: Sun, 11 Jan 2009 22:38:07 +0100
From: "Maciej Rutecki" <maciej.rutecki@gmail.com>
To: "Jesper Juhl" <jj@chaosbits.net>
Subject: Re: Linux 2.6.29-rc1
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Jeff Garzik" <jgarzik@pobox.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.0901112232030.6354@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.2.00.0901101551420.6528@localhost.localdomain>
	 <8db1092f0901111328m5bf74c8bh6361f8845f767d45@mail.gmail.com>
	 <alpine.LNX.2.00.0901112232030.6354@swampdragon.chaosbits.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/11 Jesper Juhl <jj@chaosbits.net>:
> On Sun, 11 Jan 2009, Maciej Rutecki wrote:
>
>> During booting system stops on this message:
>> http://unixy.pl/maciek/download/kernel/2.6.29-rc1/laptop/img_0001.jpg
>>
>> Probably I have two separate problems: warning (fragment is visible on
>> top) and freeze of system. I try bisect, but I have problem:
>>
>> root@gumis:/usr/src/git/linux-2.6# git bisect start
> ...snip...
>>
>> I have only "fs" and ".git" directory after last "git bisect good".
>> How to avoid this problem?
>>
> See the thread with Subject "Subject: current git kernel has strange
> problems during bisect" -
> http://groups.google.com/group/fa.linux.kernel/browse_thread/thread/c8009969743b80c1/6bcc34db7b940309?show_docid=6bcc34db7b940309
> Especially the first post by Linus that tells you how to deal with it.

Thanks, I will try this.
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
