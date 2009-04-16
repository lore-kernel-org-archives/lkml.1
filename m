Return-Path: <linux-kernel-owner+w=401wt.eu-S1755360AbZDPAsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360AbZDPAsc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 20:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755675AbZDPAsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 20:48:05 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:47057 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755621AbZDPAsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 20:48:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=h7fG9LwN0wsnZV+gzgxH9PebQ+T+9+Ired1lkRy3IMamV4r1gEU37J2UIOjxf6Cgbg
         lHL3CUAJTbEAkalo3o/27sLtHLqt7DMqtGcT0vBkIk23xmSBOfVZ2cZQjVjzDNTYRcNZ
         TTNgvFMgOllE7JaydP+dYRAbS3rG3BVxqopbQ=
Message-ID: <49E6803C.6010602@gmail.com>
Date: Wed, 15 Apr 2009 18:47:56 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Tilman Schmidt <tilman@imap.cc>
CC: Tomasz Chmielewski <mangoo@wpkg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Fast testing
References: <49E5D0C1.6010608@wpkg.org> <49E5D6D9.3040903@imap.cc>
In-Reply-To: <49E5D6D9.3040903@imap.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tilman Schmidt wrote:
> Tomasz Chmielewski schrieb:
>>> Wow. Nice machine. I wish I had one like that. And how long until
>>> the GUI is usable again and you can actually continue working?
>>>
>>> For comparison: my 3.4 GHz Pentium D takes 30 secs for kernel start
>>> (ie. until it begins looking for the filesystems),
>> Including all BIOS routines?
> 
> No - from hitting Enter in the GRUB menu.

That seems really high, unless you're using some storage driver that 
takes a really long time to initialize or something..

> 
>>>  2 mins until the graphical login screen appears, and
>>> 5 mins from logging in to the GUI being completely present.
>> I have an old 366 MHz / 192 MB machine which boots to GUI much faster.
> 
> Might depend on the value of "GUI". Mine wouldn't even load in 192 MB.
> Anyway, my preceding P3/700 MHz/512 MB box hasn't been much worse,
> either.
> 
>> Something's wrong with your setup (unless you start really lots of 
>> things or have some other, "uncommon" things).
> 
> Hmm, it's always been like that. As for "uncommon", this is a more
> or less out of the box openSUSE 10.3 installation. (Without Beagle,
> in case you were wondering.) Perhaps that's what's wrong? :-)
> 
> OTOH, even the GUIless CentOS server boxes I look after for a
> living take about 5 mins until they are up and running again after
> a kernel update - including BIOS, but without the fsck penalty.
> 
> Thanks,
> Tilman
> 

