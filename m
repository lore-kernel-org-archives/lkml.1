Return-Path: <linux-kernel-owner+w=401wt.eu-S1755777AbZGUSc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777AbZGUSc3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 14:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755721AbZGUSc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 14:32:28 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:61638 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755706AbZGUSc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 14:32:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uMa6o4KSbc074uvsS6unQw3Swe3HMpboY8ZQtKXrkjZHChqJA9E7yUcC9/QA1L+t23
         qwdpGH4A0QGprVXgl6HsaJVj0j9hBJ4Qtt6qMWH+iqQsO8JAsjVtTZbxJyPSUCgQPufx
         BmisYGmonVi2FrzOqCBZ/VHdQfueT2ntw0Bhc=
MIME-Version: 1.0
In-Reply-To: <4A647277.4000009@superbug.demon.co.uk>
References: <4A647277.4000009@superbug.demon.co.uk>
Date: Tue, 21 Jul 2009 20:32:26 +0200
Message-ID: <8db1092f0907211132s1f77b376yadee21a2f60498c@mail.gmail.com>
Subject: Re: Disk access just before shutdown power off.
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: James Courtier-Dutton <James@superbug.demon.co.uk>
Cc: kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/20 James Courtier-Dutton <James@superbug.demon.co.uk>:
> Hi,
>
> When I shutdown my Linux laptop, it does an orderly shutdown with quite
> a lot of HD activity during shutdown which eventually stops when the
> screen goes blank. Then there is some delay (5-10 seconds) and then a
> quick flurry of HD access just before it powers itself off.
> Why is this last bit of HD access needed?
> Surely, if the system is shut down enough to not use the screen any
> more, why does it need the HD?
> I am asking, because it would be nice to disable this need of the HD
> just before it powers itself off. This would allow me to lift up the
> laptop just a bit earlier and place it in my backpack when the screen
> blanks without having to worry about HD failure due to shock.
> I think it would be nicer if the HD would shut itself down just before
> the screen goes blank.
>

It's HP/Compaq laptop?

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
