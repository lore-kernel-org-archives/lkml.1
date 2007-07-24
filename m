Return-Path: <linux-kernel-owner+w=401wt.eu-S1759961AbXGXDrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759961AbXGXDrS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 23:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755264AbXGXDrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 23:47:03 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:36874 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754875AbXGXDrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 23:47:01 -0400
Message-ID: <46A575C8.80208@gmail.com>
Date: Tue, 24 Jul 2007 05:45:12 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Bill Davidsen <davidsen@tmr.com>
CC: Al Boldi <a1426z@gawab.com>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFH] Partion table recovery
References: <200707200813.03553.a1426z@gawab.com> <46A50AD6.6050806@tmr.com>
In-Reply-To: <46A50AD6.6050806@tmr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2007 10:08 PM, Bill Davidsen wrote:

> Al Boldi wrote:

>> As always, a good friend of mine managed to scratch my partion table 
>> by cat'ing /dev/full into /dev/sda.  I was able to push him out of the 
>> way, but at least the first 100MB are gone.  I can probably live 
>> without the first partion, but there are many partitions after that, 
>> which I hope should easily be recoverable.
>>
>> I tried parted, but it's not working out for me.  Does anybody know of 
>> a simple partition recovery tool, that would just scan the disk for 
>> lost partions?
>>   
> You have gotten a bunch of thoughts on this, I will just say that plain 
> old "fdisk -l" saved somewhere safe is probably all you need, in human 
> readable format. Doesn't do you any good now, but all the complicated 
> schemes discussed don't thrill me, I want to be able to see this, and 
> recovery by partition table manual rebuild is so rare I would rather do 
> it by hand than trust some software I rarely use.

ACK. Or NNAK (Non-NAK) at least...

Rene.

