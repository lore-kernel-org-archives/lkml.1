Return-Path: <linux-kernel-owner+w=401wt.eu-S1755770AbYGOLbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770AbYGOLbS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 07:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753029AbYGOLbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 07:31:04 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:60986 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851AbYGOLbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 07:31:03 -0400
Date: Tue, 15 Jul 2008 13:31:00 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Stoyan Gaydarov <stoyboyker@gmail.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, gorcunov@gmail.com,
       akpm@linux-foundation.org
Subject: Re: From 2.4 to 2.6 to 2.7?
In-Reply-To: <87skubxxtq.fsf@basil.nowhere.org>
Message-ID: <alpine.LNX.1.10.0807151319090.13215@fbirervta.pbzchgretzou.qr>
References: <6d291e080807141910m573b29b2t753ea7c4db09902d@mail.gmail.com> <alpine.LFD.1.10.0807141914280.3017@woody.linux-foundation.org> <87skubxxtq.fsf@basil.nowhere.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 2008-07-15 12:10, Andi Kleen wrote:
>Linus Torvalds <torvalds@linux-foundation.org> writes:
>>
>> So if the version were to be date-based, instead of releasing 2.6.26, 
>> maybe we could have 2008.7 instead. Or just increment the major version 
>> every decade, the middle version every year, and the minor version every 
>> time we make a release. Whatever.
>
>Or you could just do it like emacs or Solaris and simply use a single number.

And both emacs and Solaris already have high numbers.
For the former that's probably warranted given its long existence.
Solaris, hm no, but the "SunOS 5.11" tag on the other hand,
is quite "acceptable".

Big numbers tend to be forgotten. Do you know offhand what the latest
MSOffice is? emacs? udev? less? I doubt you do.
My intuitive answers were:
12, 22, "somewhere in the 100s", "somewhere in the 400s".
Reality? I had to look up the last two.
12(.with.an.oodle.of.digits), 22.2, 124, 418/424(beta).
Maybe Linux would be different because you see the version on
some login prompts, dmesg, or similar.
