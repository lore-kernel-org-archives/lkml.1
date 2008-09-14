Return-Path: <linux-kernel-owner+w=401wt.eu-S1754806AbYINO1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbYINO1U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 10:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753774AbYINO1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 10:27:13 -0400
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200]:51843 "EHLO
	mta5.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472AbYINO1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 10:27:12 -0400
Date: Sun, 14 Sep 2008 10:27:10 -0400
From: Steven Toth <stoth@linuxtv.org>
Subject: Re: [linux-dvb] Multiproto API/Driver Update
In-reply-to: <d9def9db0809131910h2ff43b9auf86eb340adb2fac8@mail.gmail.com>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Manu Abraham <abraham.manu@gmail.com>, linux-dvb@linuxtv.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <48CD1F3E.6080900@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <466109.26020.qm@web46101.mail.sp1.yahoo.com>
 <48C66829.1010902@grumpydevil.homelinux.org>
 <d9def9db0809090833v16d433a1u5ac95ca1b0478c10@mail.gmail.com>
 <48CC42D8.8080806@gmail.com>
 <d9def9db0809131556i6f0d07aci49ab288df38a8d5e@mail.gmail.com>
 <48CC4D35.3000003@gmail.com>
 <d9def9db0809131910h2ff43b9auf86eb340adb2fac8@mail.gmail.com>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Markus Rechberger wrote:
> On Sun, Sep 14, 2008 at 1:31 AM, Manu Abraham <abraham.manu@gmail.com> wrote:
>> Markus Rechberger wrote:
>>> On Sun, Sep 14, 2008 at 12:46 AM, Manu Abraham <abraham.manu@gmail.com> wrote:
>>>> Markus Rechberger wrote:
>>>>
>>>>> How many devices are currently supported by the multiproto API
>>>>> compared with the s2 tree?
>>>> The initial set of DVB-S2 multistandard devices supported by the
>>>> multiproto tree is follows. This is just the stb0899 based dvb-s2 driver
>>>> alone. There are more additions by 2 more modules (not devices), but for
>>>> the simple comparison here is the quick list of them, for which some of
>>>> the manufacturers have shown support in some way. (There has been quite
>>>> some contributions from the community as well.):
>>>>
>>>> (Also to be noted is that, some BSD chaps also have shown interest in
>>>> the same)
>>>>
>>> they're heavy into moving the whole framework over as far as I've seen
>>> yes, also including yet unmerged drivers.
>>
>> Using the same interface, the same applications will work there as well
>> which is a bonus, but isn't the existing user interface GPL ? (A bit
>> confused on that aspect)
>>
> 
> I think it's good to have something that competes with Linux, I talked to some
> guys at that front too, and they seem to work close with application
> developers too
> As for the em28xx driver I agreed with pushing all my code (in case of
> linux, which
> includes unmerged independent drivercode from manufacturers) into their system
> using their license.

Something that competes with Linux, absolutely, I could not agree more - 
especially if the licenses are compatible and cross O/S pollination of 
ideas/code can occur. Everyone benefits from this.

Hauppauge had a guy from the BSD community contact us and ask for 
datasheets for certain parts. Part of the problem, as I understand it, 
is that the BSD folks can't port the GPL license into BSD because it's 
not compatible.

I owe it to myself to spend somehime reading the BSD licencing. Maybe 
the GPL is compatible with BSD.

Just my 2 cents.

- Steve

