Return-Path: <linux-kernel-owner+w=401wt.eu-S933871AbZLFPlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933871AbZLFPlK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 10:41:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933833AbZLFPlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 10:41:09 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:61944 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933832AbZLFPlI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 10:41:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vuBhlWH+/XalBDtCuSYrY/7+c4tCTlKWYkGpH7c5i8abT6iLItgeNQwFEbDvmAqbZN
         /CircGPoPAH+4K84eKzRsv6Y7+afTQzR5t1hH0Q7VjhNJ7T7Zq7BykktDhEa+YyNpAqx
         JSsPpJTSFFAXDgYEIHlZXTIwD4W4Bsg2ELQLo=
MIME-Version: 1.0
In-Reply-To: <4B1A53AE.9020707@tremplin-utc.net>
References: <40a4ed590911190052w63a18bb7p516a5e759e0ffa23@mail.gmail.com>
	 <4B055609.9030306@tremplin-utc.net>
	 <4B1A53AE.9020707@tremplin-utc.net>
Date: Sun, 6 Dec 2009 16:41:14 +0100
Message-ID: <40a4ed590912060741n4042ab1bg8188cd4eff28ca78@mail.gmail.com>
Subject: Re: Intel Poulsbo [psb] driver for Asus Eeepc 1101
From: Zeno Davatz <zdavatz@gmail.com>
To: =?ISO-8859-1?Q?=C9ric_Piel?= <Eric.Piel@tremplin-utc.net>
Cc: linux-kernel@vger.kernel.org, Zac Medico <zmedico@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 5, 2009 at 1:35 PM, Éric Piel <Eric.Piel@tremplin-utc.net> wrote:
> Op 19-11-09 15:28, Éric Piel schreef:
>> Op 19-11-09 09:52, Zeno Davatz schreef:
>>> Hi
>>>
>>> I am looking for the Asus Eeepc Poulsbo (psb) driver in Kernel
>>> 2.6.32-rc7. When is this driver expected to make it into the kernel?
> :
>> Hi,
>> I'd also be interested by a patch to get the psb kernel module to
>> compile with 2.6.32. If anyone has this already available, please post it!
>> Or maybe someone knows what should be done to fix this type of errors?
> Hello,
>
> I've just noticed that Zac Medico has written the fixes (as sed scripts)
> for the psb driver in gentoo. Below is the patch version of his fixes.
> It works for me :-)

Ok, it does compile but when I insert the module I get:

psb: Unknown symbol i2c_bit_add_bus

I got the exact same error with 2.6.29

Best
Zeno
