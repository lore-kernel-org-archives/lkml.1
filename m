Return-Path: <linux-kernel-owner+w=401wt.eu-S1756306AbXKISxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306AbXKISxq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 13:53:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753233AbXKISxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 13:53:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48758 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbXKISxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 13:53:38 -0500
Message-ID: <4734ACAD.3060001@zytor.com>
Date: Fri, 09 Nov 2007 10:53:33 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23: GRUB reports "Setup signature not found"
References: <47348F54.2080507@redhat.com>	<20071109085905.3c2a78cd.rdunlap@xenotime.net>	<4734A9B6.1080404@zytor.com> <20071109104635.11e504d2.rdunlap@xenotime.net>
In-Reply-To: <20071109104635.11e504d2.rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Fri, 09 Nov 2007 10:40:54 -0800 H. Peter Anvin wrote:
> 
>> Randy Dunlap wrote:
>>> On Fri, 09 Nov 2007 11:48:20 -0500 Chuck Ebbert wrote:
>>>
>>>> Multiple people have now reported this error message with 2.6.23.
>>>> Updating GRUB fixes it:
>>>>
>>>> https://bugzilla.redhat.com/show_bug.cgi?id=370391
>>>> https://bugzilla.redhat.com/show_bug.cgi?id=371321
>>> Thanks for the info.
>>> A better fix IMHO would be if one could get lilo to work.  :)
>>>
>>> ---
>>> ~Randy [who is fed up with grub]
>> BTW, I definitely can agree with your feeling about grub (which is part 
>> of why I maintain a different boot loader suite.)  However, if you know 
>> of any LILO problems, please speak up.
> 
> I don't know of any lilo-specific problems and didn't mean to imply
> that LILO is at fault.
> 
> The problems that I have seen when I have tried to switch from
> grub to LILO are more like config issues:
> either "can't find root device" or
> "cannot open /dev/console" or other initrd/initramfs issues.
> 

OK.  I'd be interested in your experience if you'd be willing to try out 
syslinux (extlinux).

	-hpa
