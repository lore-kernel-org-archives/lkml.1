Return-Path: <linux-kernel-owner+w=401wt.eu-S1755147AbYCQVVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147AbYCQVVp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 17:21:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbYCQVVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 17:21:38 -0400
Received: from styx.suse.cz ([82.119.242.94]:54300 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752632AbYCQVVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 17:21:37 -0400
Date: Mon, 17 Mar 2008 22:21:36 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Michael Hanselmann <linux-kernel@hansmi.ch>
cc: linux-kernel@vger.kernel.org, michel@tungstengraphics.com
Subject: Re: [PATCH] Update key codes for Apple aluminium keyboards
In-Reply-To: <20080317201852.GA30667@hansmi.ch>
Message-ID: <Pine.LNX.4.64.0803172220190.30831@jikos.suse.cz>
References: <20080317161826.GA29601@hansmi.ch> <Pine.LNX.4.64.0803171759390.30831@jikos.suse.cz>
 <20080317201852.GA30667@hansmi.ch>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="336216065-2041315493-1205788896=:30831"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--336216065-2041315493-1205788896=:30831
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Mon, 17 Mar 2008, Michael Hanselmann wrote:

> ---
> F5 and F6 have no second function printed on them. Thus their
> definitions have been removed from the table.
>=20
> KEY_CYCLEWINDOWS doesn't name the function of Mac OS X' Expos=E9 properly
> and because we couldn't find a better key code, we decided to use
> KEY_FN_F4 instead.
>=20
> We also changed KEY_BACK and KEY_FORWARD, which apply to browser
> functions, to KEY_PREVIOUSSONG and KEY_NEXTSONG, since the keys are
> intended to control a music player.
> ---
> Does this contain enough details?

It indeed does. I will queue it in my tree, thanks a lot.

--=20
Jiri Kosina
SUSE Labs
--336216065-2041315493-1205788896=:30831--
