Return-Path: <linux-kernel-owner+w=401wt.eu-S1757213AbYGPA15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213AbYGPA15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 20:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753706AbYGPA0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 20:26:09 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:20337 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759195AbYGPA0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 20:26:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=RkvB5KlW+a7OoCz0PsYiBOF4zxE8hyylOVUD04kAgGvXbnazn/cUTIU5+YHr/BQayR
         mKgqIEzQOoq5ncIyCG/0OyQmadg6yG7CQWCO+MKmf+7x5Es2IRx8FXVrBBgsQKWmowGJ
         NNIJs+lp5fsashFf4NOMXkqZuLHh+Zf3/lDE4=
Message-ID: <dd18b0c30807151726i622dabceve31828460085ee57@mail.gmail.com>
Date: Wed, 16 Jul 2008 00:26:05 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Jack Howarth" <howarth@bromo.msbb.uc.edu>
Subject: Re: 2.6.26-rc9-git9 doesn't boot on Macintel
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080715231118.GA26807@bromo.msbb.uc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30807151252w7edcea19t8cec5ec5f958c7c0@mail.gmail.com>
	 <20080715231118.GA26807@bromo.msbb.uc.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 11:11 PM, Jack Howarth
<howarth@bromo.msbb.uc.edu> wrote:
> Justin,
>    Could you try the following. I find that if I download the
> current boot.iso image for rawhide (which is around 107Mb)
> and burn it onto a cd that I see the same exact hang under
> i386 on my MacBook Pro. You can download the image from...
>
> http://mirrors.kernel.org/fedora/development/i386/os/images/
>
> I booted directly to the CD with the C key depressed on startup
> and selected the F5 option to enter linux rescue mode. You should
> find that as the linux kernel is booted for that mode that the
> hang will occur.
>                   Jack
> ps The current rawhide is based on 2.6.26 of course.
>
> On Tue, Jul 15, 2008 at 07:52:08PM +0000, Justin Mattock wrote:
>> Hello;
>> did you have a chance to try my .config
>> to see if this was just a simple .config issue?
>> keep in mind there are some unneeded
>> modules in this .config, just been too lazy
>> to clean my .config, if you need a clean .config
>> go here:http://www.odi.ch/prog/macbookpro/index.php
>> anyways hope this is only the issue you are facing.
>> regards;
>>
>> --
>> Justin P. Mattock
>

Ah I see, so this is from a fresh .iso image
I can give you're suggestion a try(need to locate a blank cd)
keep in mind the .iso might not have x86 support i.g.
I use nubuntu(why: it's small) one of the problems I was facing was
the alpha release, which did not support x86(when using that .iso image
it would start booting and then spit out a bunch of messages vertically,
but a few month's later they released there .iso with support thus
giving me the opportunity to use it.
This might be what you are dealing with.
regards;

-- 
Justin P. Mattock
