Return-Path: <linux-kernel-owner+w=401wt.eu-S1755505AbYFWNDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbYFWNDK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 09:03:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbYFWNDC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 09:03:02 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:53178 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbYFWNDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 09:03:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=xL3Q+Tfy5jZpMPpvzgzIRSqMjIk9VoI4Wq5GL5c/gE7kXpQcDrTUMSZf/M5pQtN/BU
         PAC5hAjsSzaKdZx7Pl3CEPirojmvUPh2aOTLBHMmbn0YKjqZpFHp9mAUkJZufxCrPKAk
         WpQiPMyR6/LTLhWEEtk4/ycETI3OifcNY2zsw=
Message-ID: <e85b9d30806230602m10b5aa06m2f1c83e1a90a7dac@mail.gmail.com>
Date: Mon, 23 Jun 2008 15:02:58 +0200
From: Matthew <jackdachef@gmail.com>
To: greg@kroah.com, "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [ANNOUNCE] Position Statement on Linux Kernel Modules
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

I largely agree to this statement,

there are however some downsides if you're preventing driver
manufacturers (e.g. nvidia, ...) from the possibility to offer their
customers proprietary drivers:

1) One big and important point for me (and more and more future
linux-users) is powersaving features on GPUs like powermizer (by
nvidia) and powerplay (by AMD/ATI) or other hardware. I haven't seen
this working on newer graphics cards models with the opensource
drivers to the present day :(

Take an example with laptops: where with the proprietary drivers it is
possible to work 6 hours of uptime, you'll only get 1.5 hours of
battery time on laptops; additionally / or on desktops you'll be
getting a fan which will always run on the highest velocity,
considering the big generation of heat on your lap and you're getting
a very uncomfortable work device.
Isn't this also at odds with the green direction linux is heading
towards right now?

This surely also applies to manufacturers of future linux-powered
devices such as handsets (cell phones), routers, etc etc
if those companies can't use their own closed proprietary drivers
utilizing patented routines they are "forced" to use, they might think
over it and switch to another operating system ...

2) How will this affect performance, if all of those drivers are
limited to an user-space interface?

I'm not a kernel hacker and don't have much insight into the kernel
and kernel-development, so I can only reflect, what I've read:
much of you kernel hackers are supposed to have said (read that on
blogs, forums etc.) that nvidia's drivers are hackish and that it uses
routines which shouldn't be used by this kind of drivers

other voices are saying nvidia is doing this because the linux-kernel
lacks a common interface (yet) which disallows effective usage of the
graphics cards which would result in abysmal bad performance not using
their hacking ...

so perhaps sitting together with those companies and creating such an
effective interface might be the solution ? :)

3) I know that desktop users are not THAT important for you (linux is
mainly oriented towards industrial usage)
but think of the desktop users as of additional testers and potential
new kernel-hackers which would one day work for the common good
(having great new ideas, e.g. filesystems, io-schedulers, etc etc)
preventing those users/future developers from using their (needed)
devices will drive them away from using GNU/Linux and also those young
talented minds, those drivers are "necessary evil", after all

4) We should never forget who / what allowed this kind of development
and openness: the GPL, GNU and Richard Stallman, Linus Torvalds (only
to name a few)

We are deeply obliged to ensure this freedom in development and usage,
this however shouldn't go that far to prevent users of the code to
combine with it what they need to

This were just a few of the feelings floating in my head after having
read your position statement,

you're heading towards the right direction but please, please don't
forget the community, after all :)

this is about ideology to a big fraction, yes, but we shouldn't forget
the freedom after all

Thanks,

Regards,

Mat
