Return-Path: <linux-kernel-owner+w=401wt.eu-S935026AbZLGKSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935026AbZLGKSN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 05:18:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934916AbZLGKSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 05:18:13 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:60722 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934999AbZLGKSM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 05:18:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VR5U2HklDsjPjMhHUG6KUlaDUV1ML3/LqjEt/UYQwjHJs84zbmIGT81vwbnocevDwk
         O6J4Hak//s6/U4TGfMCeyl/91K4FuMZJNqlktKYEA46KgFtw3UWz00xODq+Ep6wpWasn
         r3nxiOiS50X3Ifcl2bogToCM3WQB/Hu+uDBAk=
MIME-Version: 1.0
In-Reply-To: <4B1CD457.3060801@tremplin-utc.net>
References: <40a4ed590911190052w63a18bb7p516a5e759e0ffa23@mail.gmail.com>
	 <4B1A53AE.9020707@tremplin-utc.net>
	 <40a4ed590912060741n4042ab1bg8188cd4eff28ca78@mail.gmail.com>
	 <4B1BDAA3.10601@gentoo.org>
	 <40a4ed590912060835s61aea6aqfe6780395bfd2993@mail.gmail.com>
	 <4B1C38B5.2060204@tremplin-utc.net>
	 <40a4ed590912070143j231e07b6uafd04d0f2ee15dca@mail.gmail.com>
	 <4B1CD029.3080503@tremplin-utc.net>
	 <40a4ed590912070202q30852e2fo35023f557919966e@mail.gmail.com>
	 <4B1CD457.3060801@tremplin-utc.net>
Date: Mon, 7 Dec 2009 11:18:17 +0100
Message-ID: <40a4ed590912070218i5a851773t6307d73c1d613c33@mail.gmail.com>
Subject: Re: [OT] Re: Intel Poulsbo [psb] driver for Asus Eeepc 1101
From: Zeno Davatz <zdavatz@gmail.com>
To: =?ISO-8859-1?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>
Cc: Zac Medico <zmedico@gentoo.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 7, 2009 at 11:09 AM, Éric Piel <eric.piel@tremplin-utc.net> wrote:
> Op 07-12-09 11:02, Zeno Davatz schreef:
> :
>> Not the same on Gentoo. I think I have to find the kernel boot-option
>> that I can pass to lilo.
>>
>> Also: When I force remove the modules psb and drm_psb with "rmmod -f"
>> and then start X I get the same error:
>>
>> X: symbol lookup error: /usr/lib/xorg/modules/drivers/psb_drv.so:
>> undefined symbol: LoaderRefSymLists
>>
>> X just does not yet like psb.
> You are also aware that it does not work on Xserver 1.7, right? 1.6 is
> the the maximum.

Thanks. I thought it should work with 1.7 as well. Will try that then.

Best
Zeno
