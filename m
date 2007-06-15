Return-Path: <linux-kernel-owner+w=401wt.eu-S1753655AbXFOKxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655AbXFOKxR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 06:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752521AbXFOKxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 06:53:04 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:48185 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbXFOKxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 06:53:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=PC5yjpUrME8Vtj8wONtiFKZ/bnzm3HS8nlb1/JRU9OJbZr4w1ok8GZpaRcstNiKNWYCplaTrATJug9xdTGO4MMUq5rtQsz1nAfuXW31AOtlMCUIBzc5MpTPQp6mVOx0kGhFxFe3OKK10clT0xib1QXX2FWeBMI0d0sW7xjYzvO8=
Message-ID: <9a8748490706150353i452cf529oc5c0e8119f91e64e@mail.gmail.com>
Date: Fri, 15 Jun 2007 12:53:01 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Nicolas Mailhot" <nicolas.mailhot@laposte.net>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Cc: "Daniel Hazelton" <dhazelton@enter.net>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/06/07, Nicolas Mailhot <nicolas.mailhot@laposte.net> wrote:
> >> > by your argument, the user has some "right to modify the
> software", on
> >> > that piece of hardware it bought which had free software on it,
> correct?
> >>
> >> Yes.  This means the hardware distributor who put the software in
> >> there must not place roadblocks that impede the user to get where she
> >> wants with the software, not that the vendor must offer the user a
> >> sport car to take her there.
>
> >Okay. That means that if I ship Linux on a ROM chip I have to somehow
> make
> >it so that the person purchasing the chip can modify the copy of Linux
> >installed on the chip *if* I want to follow both the spirit and the
> letter
> >of the GPLv2.
>
> The key word there is "can"
>
> You don't have to send the buyer the hardware design, replace the ROM
> with a flash, use a rom socket that allows easy switching etc.
>
> But you can not add measures to your hardware specifically designed to
> stop the user from modifying the GPL software part. Especially if
> those measures are something like DRM that do not make the tinkering
> just technically hard, but legally forbidden.
>
> As long as the restrictions result from technical choices not
> targetted at forbidding changes you're ok.
>
That's simply not true.

As long as you get a copy of the source code for the software that's
running on the hardware it's OK. That's all the GPLv2 says.

If you buy a computer with a GPLv2 OS on it and GPLv2 applications
running on it and recieve a CD-ROM with a copy of all the source code
along with the computer, then whomever supplied you with that is in
compliance with the GPLv2. This is true even if the computer does not
allow you (by whatever means) to install or modify in any way the
software currently installed on it. It's still true even if the
manufacturer has a means to change the installed software.
You have the right to modify, distribute etc the copy of the source
code you obtained on the CD-ROM, that is the right granted to you by
the GPLv2 - that does not somehow include the right to nessesarily
execute the modified software on the specific hardware supplied to you
by the manufacturer.  You can still use the modified software on some
other compatible computer (if you can find one), you can still use
parts of the modified software in other GPLv2 projects, you can still
redistribute your copy of the source code to other people.
You may not *like* the fact that you don't automatically get the right
to execute a modified copy on the hardware that the software was
originally designed for, you may not think it's morally the way things
should be, you may think its unfair, but that's all irrelevant. Fact
is, the hardware manufacturer is in its full right to lock you out of
their hardware, as long as they have supplied you with the source code
to the GPLv2 software that is running on the hardware - whether or not
you can actually use that source code for anything meaningful without
their hardware is not their problem.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
