Return-Path: <linux-kernel-owner+w=401wt.eu-S1751525AbYK3GXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525AbYK3GXp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 01:23:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750798AbYK3GXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 01:23:36 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:23114 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbYK3GXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 01:23:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=yDk7TQC4Kz5cu5h25SI+LyxlVME6B2N8G3UKdphyUROx9D+cuSl9FhGrlcNyWQ7eAi
         J8dts9Kp4RUhShdaDhcCf9oonbcKRSwxDK+FpH05e092yY9tWH5PAO8umkCcgPgFeqD7
         9zOiG7TZYTqKMi9vhBcDtvftCLuxTrjiPlY3M=
Message-ID: <d9def9db0811292223j5836c1d1mae30da0438c9b638@mail.gmail.com>
Date: Sun, 30 Nov 2008 07:23:32 +0100
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [PATCH 1/7] Adding empia base driver
Cc: "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Aidan Thornton" <makosoft@googlemail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081128200953.GA24406@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9def9db0810221414w5348acf3re31a033ea7179462@mail.gmail.com>
	 <20081022220903.GA15278@kroah.com>
	 <d9def9db0810221524m738b838bs681c0b9159531c64@mail.gmail.com>
	 <c8b4dbe10811261112w6cbbec73mb468870f206d9f97@mail.gmail.com>
	 <d9def9db0811262025v5d1b0df4h3855cb6023be2cf7@mail.gmail.com>
	 <84144f020811270133r179828eat69b24c067c55447@mail.gmail.com>
	 <20081128200953.GA24406@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2008 at 9:09 PM, Greg KH <greg@kroah.com> wrote:
> On Thu, Nov 27, 2008 at 11:33:03AM +0200, Pekka Enberg wrote:
>> On Thu, Nov 27, 2008 at 6:25 AM, Markus Rechberger
>> <mrechberger@gmail.com> wrote:
>> > I simply don't have the time for those games anymore, and those people here who have personal
>> > issues with me and/or my work don't pay my monthly bills, neither do they have any clue how that
>> > driver is used with some systems of certain customers. I constantly deliver full solutions, and not
>> > driver code only. Neither am I limited to Linux only.
>>
>> Again, it's not personal, it's the way we do things here. But you
>> should already know that by now so whatever.
>>
>> What puzzles me the most here is why isn't Empia simply providing
>> datasheets to other developers as well. I mean, even the GPU and
>> wireless vendors know how to play well with the community now, so
>> what's the problem? Being locked to just one developer who's unwilling
>> to cooperate doesn't sound like a winning strategy to me.
>>
>> Greg, is there any reason we don't have Markus' out-of-tree driver
>> listed here, btw:
>>
>>   http://www.linuxdriverproject.org/twiki/bin/view/Main/OutOfTreeDrivers
>
> It's a wiki, feel free to add it yourself :)
>
> thanks,
>
> greg k-h
>

hah I fully understand now. I've been blind. There's no better way to
go than the current one for
someone here who recently got hired at Redhat even if he doesn't
deserve it for real.

I hope some other people are able to convince me about OSS again. I
have alot respect of
ffmpeg people actually. Writing v4l drivers is damn easy actually
callbacks here callbacks there
learning some structs and dumping data 1:1 to userland and someone is
done already.

This is the second project which goes that way, the first one was
polite enough to just take my
code and remove the copyrights .. after noticing this - after a year-
I got a nice reply that the work
was inspired by even when containing the same comments...

this is my last email to LKML, even when continuing to support Linux I
won't loose focus at other
operating systems. Thanks for teaching me about GPL stuff, I now have
more faith into the BSD
license if at all in the OSS area.

Markus
