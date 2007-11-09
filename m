Return-Path: <linux-kernel-owner+w=401wt.eu-S1756105AbXKISlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbXKISlO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 13:41:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754603AbXKISk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 13:40:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38326 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288AbXKISk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 13:40:58 -0500
Message-ID: <4734A9B6.1080404@zytor.com>
Date: Fri, 09 Nov 2007 10:40:54 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23: GRUB reports "Setup signature not found"
References: <47348F54.2080507@redhat.com> <20071109085905.3c2a78cd.rdunlap@xenotime.net>
In-Reply-To: <20071109085905.3c2a78cd.rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Fri, 09 Nov 2007 11:48:20 -0500 Chuck Ebbert wrote:
> 
>> Multiple people have now reported this error message with 2.6.23.
>> Updating GRUB fixes it:
>>
>> https://bugzilla.redhat.com/show_bug.cgi?id=370391
>> https://bugzilla.redhat.com/show_bug.cgi?id=371321
> 
> Thanks for the info.
> A better fix IMHO would be if one could get lilo to work.  :)
> 
> ---
> ~Randy [who is fed up with grub]

BTW, I definitely can agree with your feeling about grub (which is part 
of why I maintain a different boot loader suite.)  However, if you know 
of any LILO problems, please speak up.

	-hpa
