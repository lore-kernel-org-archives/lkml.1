Return-Path: <linux-kernel-owner+w=401wt.eu-S965874AbXCFLwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965874AbXCFLwH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 06:52:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965873AbXCFLwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 06:52:07 -0500
Received: from hu-out-0506.google.com ([72.14.214.232]:59644 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965871AbXCFLwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 06:52:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Awkfncmj441UEx988xPC5iVLe5SoBKhq+WyYPBN/X5Rp8f/VoJPIszzlLCKH3TApLiJgjxaTgdBmDwKOLjEa1Sjvzjk69OW/1CC6Nca4LAF/6phaHJxHJRoeAKA4ZKJNGCGg2c2qvNTwTUzIsYwiqzhpwo0SWcVaIej6fO424D8=
Message-ID: <de7d5bbe0703060352p49973ff0x78907b0b53231163@mail.gmail.com>
Date: Tue, 6 Mar 2007 11:52:01 +0000
From: "Harold Sargeant" <harold-sargeant@ntlworld.com>
To: "Li Yu" <liyu@ccoss.com.cn>
Subject: Re: [linux-usb-devel] [DOC] The documentation for HID Simple Driver Interface 0.5.0
Cc: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       "Jiri Kosina" <jikos@jikos.cz>,
       "Vincent Legoll" <vincentlegoll@gmail.com>,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       "Greg Kroah Hartman" <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>, "Li Yu" <raise.sail@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <45ECC5A4.20203@ccoss.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703051532096508636@gmail.com>
	 <Pine.LNX.4.64.0703052304070.10909@twin.jikos.cz>
	 <d120d5000703051427r577acc82x85a70ff963b991fa@mail.gmail.com>
	 <45ECC5A4.20203@ccoss.com.cn>
X-Google-Sender-Auth: 7480cd77d00ea788
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/07, Li Yu <liyu@ccoss.com.cn> wrote:
> Dmitry Torokhov wrote:
> > If we define HID "bus" allowing drivers to bind on VID:PID and provide
> > default library module for parsing HID reports and providing access to
> > HID transports (USB/BT) then writing tiny drivers adjusting just a
> > part of hid_input_event and relying on default implemenattaion where
> > it makes sense will become a breeze.
> >
> >

> But (You may guess I will say this word :), before the HID bus or other
> better
> implementation come , I hope use the extended keys of my keyboard on
> Linux, and I guess other people
> also think same with me, so we need something here temporarily, even it
> do not merge
> into upstream code tree.

And until something better comes along I am happy to use what Li Yu
has produced (speaking as an ordinary user).

Thanks

--
Harold Sargeant
