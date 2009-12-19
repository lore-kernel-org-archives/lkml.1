Return-Path: <linux-kernel-owner+w=401wt.eu-S1753288AbZLSSqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288AbZLSSqW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 13:46:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbZLSSqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 13:46:21 -0500
Received: from mail-yx0-f119.google.com ([209.85.210.119]:48613 "EHLO
	mail-yx0-f119.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbZLSSqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 13:46:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=qQ1J/yGyjBiLxJ4YgplS1Rn0DJIs0/F/KDpqqUse+n8XKDaLm5DCp2q/AeaSZ27cEJ
         HEgC9tI3Utywv82P1Qazlwtk9m0jw/9ww5L1LgRqNoB8dJULfH9emgnbMyCvngWy6T+2
         tzDsIUo44KbBsa93rVdYyOeQ3/jEffrebAatA=
MIME-Version: 1.0
In-Reply-To: <20091219102223.506c9e9c.rdunlap@xenotime.net>
References: <8e678d3f0912190214s7ffbc3can784e8c907a6fe97@mail.gmail.com>
	 <20091219102223.506c9e9c.rdunlap@xenotime.net>
Date: Sun, 20 Dec 2009 02:46:19 +0800
Message-ID: <8e678d3f0912191046i3c536f3at275d81a83c024571@mail.gmail.com>
Subject: Re: Can not generate ALSA driver documentation via Makefile
From: Robin Steven <armrobin@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, Dunlap:

Sorry for my negligence! the issue is on default kernel version 2.6.28
of my target embedded board,
now I get the document "writing-an-alsa-driver.html" via my Linux host
gentoo, it currently use
Kernel 2.6.31-gentoo-r31.

Best regard !

= Robin

On Sun, Dec 20, 2009 at 2:22 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On Sat, 19 Dec 2009 18:14:33 +0800 Robin Steven wrote:
>
>> Hi, guy:
>>
>> I am hacking ALSA driver for my customized board, and want to study
>> the document "writing_an_alsa_driver" in
>> "Documentation/sound/alsa/DocBook", in the top directory of kernel
>> source and run:
>>
>> $ make htmldocs
>>
>> I can get all the html format document in "Documentation/DocBook", and
>> no any html document in
>> "Documentation/sound/alsa/DocBook" was converted for .tmpl to html.
>>
>> Thanks in advenced for any one can give me any idea!
>
> I guess it depends on what kernel version you are trying to use
> (and you omitted that info).
>
> With 2.6.32-git14, I see all of the input & generated alsa files
> under Documentation/DocBook/, including "writing_an_alsa_driver".
>
> Can you try a more recent (or current) kernel version?
>
> ---
> ~Randy
>
