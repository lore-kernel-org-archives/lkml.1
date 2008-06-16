Return-Path: <linux-kernel-owner+w=401wt.eu-S1752938AbYFPOzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbYFPOzg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 10:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753215AbYFPOz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 10:55:28 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:44067 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbYFPOz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 10:55:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=kWJdFJ3yUg6xgnv5mjEEAJ0ZnKGj6SySZPEzw2v5tnHKJEFh9W7vumG7rSSWAjh3OX
         9uK726qQiJnc3MlB/A0Pv8S+hHhaWGFWmmY5dqosMpYOC8g2GfRi8swFAO70gG++BLHl
         5hcw2QhURiD3K8omwodvrgwYMsX8+TJzD85fo=
Message-ID: <85e7c2fc0806160755h10d90d12l1519618de55a644d@mail.gmail.com>
Date: Mon, 16 Jun 2008 22:55:26 +0800
From: "Bob Zhang" <zhanglinbao@gmail.com>
To: "Jared Hulbert" <jaredeh@gmail.com>
Subject: Re: Does anyone run AXFS in 2.4 version of kernel ? I am trying my best to apply AXFS patches into 2.4.18
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <6934efce0805131801s633a1692ha8914a76173c2c80@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <85e7c2fc0805090919v613fb823m8dd979b8cd959889@mail.gmail.com>
	 <6934efce0805120923v636d2dbjb062d33fb861f5a2@mail.gmail.com>
	 <85e7c2fc0805131746k5284d66dj7cfac5f9138186e2@mail.gmail.com>
	 <6934efce0805131801s633a1692ha8914a76173c2c80@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jared Hulbert ,

What a pity that I found few document execept axfs code.
Although we can read the source code to get all things that we want to
know as a programmer, a good document is helpfull for understanding
the source code.

I am debugging the AXFS code and researching its implement , I think a
good document is very precious ,but there is no such .

Could you mind please introuducing your architecture design ? Detailed
info will be welcomed .

For example , ext2 file system , we will get a ext2 file system
specification, such as super block , and how to organize the
structures of ext2 , Would you mind please introducing these related
info ?

By the way , have you managed the AXFS specification ? if yes ,many
programmer will join the AXFS group .

Best Regards,
Bob


2008/5/14 Jared Hulbert <jaredeh@gmail.com>:
>> thanks for your work . we look forward your paches for 2.4.21 or
>>  2.4.18 or other 2.4.x . thanks again .
>>  In the meantime , I am compiling axfs patches in 2.4.18 .My policy is
>>  that I basicly don't changed the AXFS code , and only add some
>>  functions existed in 2.6.x into 2.4 kernel ,if necessary , I will
>>  modify it . Thus , I think such working is not rather difficult ,
>>  anyway , I am
>>  analysing the implement of AXFS code , if necessary , I will modify
>>  some functions of axfs.
>>
>>   Till now , AXFS_super.c has been almost ok . Next ,I will compile
>>  other axfs code and check some errors and warnning , and run the
>>  kernel in the skyeye which supported smdk2410 .
>
> You're free to mess around with that if you want, but what I'm going
> to release will make that a waste of time.  It's significantly
> updated.
>
