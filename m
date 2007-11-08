Return-Path: <linux-kernel-owner+w=401wt.eu-S1759988AbXKHAdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759988AbXKHAdd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 19:33:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753846AbXKHAdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 19:33:22 -0500
Received: from smtpgpe.resot.net ([217.175.160.71]:35588 "EHLO smtpgpe.ool.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866AbXKHAdV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 19:33:21 -0500
From: "werner" <werner@copaya.yi.org>
Subject: Fwd: same problem with 2.6.24-rc2
To: linux-kernel@vger.kernel.org
X-Originating-IP: 217.175.174.11
X-Mailer: Usermin 1.300
Message-Id: <1194481962.7222@copaya.yi.org>
Date: Wed, 07 Nov 2007 21:32:43 -0300 (GFT)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="bound1194481963"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--bound1194481963
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On 7/Nov/2007 20:10 werner wrote ..
> With 2.6.23-rc2 is the same problem:  it crashed at the beginning:  EIP 060 c03fdea4
> EFLAGS 00010212 EIP is at xor_sse_2+0x34/0x200
> Again during the compilation was reclaimed that <source-dir>/arch/x86/Makefile.o
> cannot be found and were certain dependencies on it not made, such a file isn't
> present in the source code (present are, f.ex. Makefile_32 , Makefile_64 ), nor
> was generated automaticaly during compilation, I think this is incorrect and the
> reason for the problems
> 
> wl
> werner@copaya.yi.org
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> On 7/Nov/2007 16:14 Andrew Morton wrote ..
> > > On Wed, 07 Nov 2007 15:55:12 -0300 (GFT) "werner" <werner@copaya.yi.org> wrote:
> > > I really don't know what's happening.  I don't understand nothing about the
> kernel
> > error reporting system.   Because of this, always when there is a problem, I
> report
> > it via e-mail to  linux-kernel@vger.kernel.org .  I don't know what people there
> > do with my messages.     
> > 
> > 
> > It went like this:
> > 
> > 1: you sent an email to linux-kernel
> > 
> > 2: I sent a reply to you and linux-kernel
> > 
> > 3: you sent a reply to me, but NOT linux-kernel!
> > 
> > In other words, you did "reply", not "reply to all", thus you removed three
> > thousand people from the discussion.  One of those people is the person who
> > created the bug which you're hitting, and that person no longer knows
> > what's happening.
> > 
> > 
> > So please go back and resend all those emails, and retain ALL Cc:'s.  Don't
> > just send them only to me.  Keep all indivisuals and all mailing lists on
> > the email Cc: list.
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> *** www.copaya.yi.org / www.monkey.is-a-geek.net ***
> O =FAnico servidor comunit=E1rio na Guiana-Francesa.  Situado no local, r=E1pido, imuno
> contra guerras / desastres na Europa.   Servi=E7o n=E3o-comercial e gratuito de:  http
> (forum, p=E1gina web), irc (chat), ftp (download), name (subdomain) .
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
*** www.copaya.yi.org / www.monkey.is-a-geek.net ***
O =FAnico servidor comunit=E1rio na Guiana-Francesa.  Situado no local, r=E1pido, imuno contra guerras / desastres na Europa.   Servi=E7o n=E3o-comercial e gratuito de:  http (forum, p=E1gina web), irc (chat), ftp (download), name (subdomain) .


--bound1194481963--

