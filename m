Return-Path: <linux-kernel-owner+w=401wt.eu-S1753251AbZKEJfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251AbZKEJfL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 04:35:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753002AbZKEJfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 04:35:10 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:40140 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840AbZKEJfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 04:35:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=GDE3+oqNeAUt3baMvNWExfqKOAcooXfEQfzwYNi8DEzsaZe06mp4X1LiJKWifD37vn
         9TlLpizZXDVD1oFiNZsT8rhXbOcfIpGubMpSKP4hcuPFMaEnUMS4uBw3KvZi15nCyGT8
         U0pvLGjEQn8OozvunzlA5Kv9/4izm3OMlvnA0=
MIME-Version: 1.0
In-Reply-To: <f42384a10911050134t37a0a812hd85ff5541423dc9f@mail.gmail.com>
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan>
	 <7004b08e0911041332x259c02afg612be7eb02e4d6bb@mail.gmail.com>
	 <Pine.LNX.4.64.0911042244030.24799@artax.karlin.mff.cuni.cz>
	 <200911042343.01957.tweek@tweek.dk>
	 <Pine.LNX.4.64.0911050019540.1469@artax.karlin.mff.cuni.cz>
	 <5659.1257387887@turing-police.cc.vt.edu>
	 <Pine.LNX.4.64.0911050329130.18234@artax.karlin.mff.cuni.cz>
	 <f42384a10911050134t37a0a812hd85ff5541423dc9f@mail.gmail.com>
Date: Thu, 5 Nov 2009 10:35:14 +0100
Message-ID: <f42384a10911050135t11a3c0d0i39410de74d870109@mail.gmail.com>
Subject: Fwd: package managers [was: FatELF patches...]
From: Marcin Letyns <mletyns@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---------- Forwarded message ----------
From: Marcin Letyns <mletyns@gmail.com>
Date: 2009/11/5
Subject: Re: package managers [was: FatELF patches...]
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>


2009/11/5 Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>:
>
>
> On Wed, 4 Nov 2009, Valdis.Kletnieks@vt.edu wrote:
>

> No, if I compile alpha version of mplayer by hand, it compiles and links
> against whatever libraries I have on my system. If I pull it out of some
> "testing" repository, it is already compiled and linked against libraries
> in the same "testing" repository and it will load the system with crap.
>
> That is the unfortunate reality of not having a binary standard :-(

Another bull, it's reality of not having precompiled package for your
distro. Try installing this on windows (not by running executable -
consider there's no executable in this case :>)! Precompiled packages
are smarter equivalents of windows exes. If there's no precompiled
package or if there's no exe you've got to compile and in your
situation mess everything up. I don't consider someone needs binary
standard etc. What you need is just precompiled packages for your
distro. If someone doesn't want to give you them, it's his fault. In
example you go at skype.com or whatever and you download single .deb
or .rpm and if you use (K)ubuntu you just click on this package and
skype or whatever will install automagically.

Btw. I don't consider such discussion should take place at lkml, so
maybe you'll start writing about this at linux.com or somewhere else?

Regards
