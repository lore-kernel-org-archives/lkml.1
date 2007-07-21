Return-Path: <linux-kernel-owner+w=401wt.eu-S934319AbXGUJEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934319AbXGUJEB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 05:04:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932473AbXGUJDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 05:03:42 -0400
Received: from cust198-202.dsl.versadsl.be ([62.166.198.202]:49061 "HELO
	idefix.wisa.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S937887AbXGUJDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 05:03:41 -0400
Date: Sat, 21 Jul 2007 11:03:37 +0200 (CEST)
From: =?ISO-8859-1?Q?Dani=EBl_Mantione?= <daniel.mantione@freepascal.org>
X-X-Sender: daniel@idefix.wisa.be
To: Bodo Eggert <7eggert@gmx.de>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Keyboard programming needs root
In-Reply-To: <E1IBaAo-00016n-7j@be1.lrz>
Message-ID: <Pine.LNX.4.61.0707211102500.27563@idefix.wisa.be>
References: <8GK58-g5-5@gated-at.bofh.it> <8IFXs-1xs-21@gated-at.bofh.it>
 <8IHcN-3pZ-5@gated-at.bofh.it> <E1IBaAo-00016n-7j@be1.lrz>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="657924-1441627593-1185008617=:27563"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--657924-1441627593-1185008617=:27563
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE



Op Thu, 19 Jul 2007, schreef Bodo Eggert:

> Dani=EBl Mantione <daniel.mantione@freepascal.org> wrote:
> > Op Thu, 19 Jul 2007, schreef Dmitry Torokhov:
> >> On 7/14/07, Daniel Mantione <daniel.mantione@freepascal.org> wrote:
>=20
> > To make this discussion productive, I want to work towards a solution. =
I
> > don't mind how I can make the keyboard work as it should, I just want i=
t
> > work. Think of the needs of a user interface, you walk through controls
> > using tab and shift+tab, put common commands under the function keys an=
d
> > shift/control/alt combinations. Cursor control in an editor is done wit=
h
> > the navigation pad on your keyboard: arrows, home/end/pgup/pgdown, plus
> > shift/control/alt combinations with them.
> >=20
> > That is all, nothing fancy. Could the kernel support a way to do this?
>=20
> It could, but nobody had the idea of combining a cooked mode and a raw mo=
de
> like DOS provides. OK, DOS did not do a good job, you had to peek the shi=
ft
> status separately, but you had the assigned character as well as the
> (translated) scancode. IIRC, X11 does the same, but with the scancodes
> (and the mouse coordinates?) included.

Well, let's go for it then. Where to start?

Greetings,

Dani=EBl Mantione
--657924-1441627593-1185008617=:27563--
