Return-Path: <linux-kernel-owner+w=401wt.eu-S1753016AbZC3Hvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbZC3Hvc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 03:51:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751504AbZC3HvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 03:51:22 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:41575 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbZC3HvW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 03:51:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PeAiOuswKJ4KqNhqnPKCbZj+t5/mWOPpqyIDcbxvpQtoXxOykvjMplbCFhmUBrOY6N
         kzEmFWy96otkTH5w/11LZtsFIaTtCwT1zzMTZrBe1SAnDG4gK1QeGc1Zv0OMLrdulZv8
         uC+S/GLauSq/30ObWIkmknNoq5dJf6TM3RyCU=
MIME-Version: 1.0
In-Reply-To: <E1Lmq3O-0001mo-Pf@be1.7eggert.dyndns.org>
References: <cicyE-3qo-15@gated-at.bofh.it> <cidXL-5OQ-35@gated-at.bofh.it> 
	<cinu8-41e-3@gated-at.bofh.it> <cisas-37w-5@gated-at.bofh.it> 
	<ciFKp-7QW-17@gated-at.bofh.it> <cj8CE-3uO-11@gated-at.bofh.it> 
	<cjo4C-3hh-13@gated-at.bofh.it> <cjoo1-3FO-13@gated-at.bofh.it> 
	<cjoxL-3SW-35@gated-at.bofh.it> <E1Lmq3O-0001mo-Pf@be1.7eggert.dyndns.org>
Date: Mon, 30 Mar 2009 17:51:05 +1000
Message-ID: <ff479ab60903300051x485f74f5tb3302a521bd8fb12@mail.gmail.com>
Subject: Re: My new fancy font for framebuffer
From: Baybal Ni <nikulinpi@gmail.com>
To: 7eggert@gmx.de
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Felipe Contreras <felipe.contreras@gmail.com>,
       Ken Moffat <zarniwhoop@ntlworld.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 26, 2009 at 23:55, Bodo Eggert <7eggert@gmx.de> wrote:
> H. Peter Anvin <hpa@zytor.com> wrote:
>> Felipe Contreras wrote:
>>>
>>> I thought you had to distribute the source code only if you made
>>> modifications. What's the point of distributing it _again_?
>>>
>>
>> a) the license requires it.
>
> No, you just have to offer the source.
>
> OTOH, if the bdf2c-translator is reasonably small, put it into the utility
> directory, define a user-stuff-directory, and write a "make fonts" section
> which will insert $CONFIG_USER_STUFF/fonts/* into the kconfig menu.
> (Or pre-define $CONFIG_USER_STUFF to a fixed directory in the kernel tree.)
>
> just my ¢¢
>
>

Ok, I leave it to linux kernel gurus. One more cool thing that sunk
under copyright FUD.
