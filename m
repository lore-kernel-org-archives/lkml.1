Return-Path: <linux-kernel-owner+w=401wt.eu-S1756628AbXFNVlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628AbXFNVlb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 17:41:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751696AbXFNVlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 17:41:23 -0400
Received: from mail.syneticon.net ([213.239.212.131]:47241 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbXFNVlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 17:41:22 -0400
Message-ID: <4671B5BB.2000203@wpkg.org>
Date: Thu, 14 Jun 2007 23:40:11 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061110 Mandriva/1.5.0.8-1mdv2007.1 (2007.1) Thunderbird/1.5.0.8 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: ext2 on flash memory
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Knutar wrote:

> On Wednesday 13 June 2007 16:48, DervishD wrote:
>>     But anyway the memory should last long. Even cheap flash memories
>> with poor wear leveling (if any at all) usually long last. Given that
>> I won't be writing continuously, wear shouldn't be a problem. I'm
>> going to use this as a backup copy of my home. Of course, I can use a
>> tarball too...
> 
> I did a test on my kingston datatraveler recently, I didn't expect it to 
> survive, but it did. I put reiserfs on it, and copied 394M of data in 
> 200,000 files to it. Reiserfs was sloooow at writing, the device was 
> probably doing alot of work. ext2 was about 10X faster, but there was 
> hardly any free space left at all at the end :)
> 
> Considering it surived ReiserFS, I suspect it would last ages with ext2, 
> especially for your backup purposes.

I have a couple of years old USB stick, which was used for swap, and for 
compiling stuff natively on some small mipsel devices, and generally 
moving files back and forth a lot (ext3 + noatime).

Still, it works just fine.


-- 
Tomasz Chmielewski
http://wpkg.org

