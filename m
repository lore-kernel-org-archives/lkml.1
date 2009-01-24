Return-Path: <linux-kernel-owner+w=401wt.eu-S1757052AbZAXN0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757052AbZAXN0T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 08:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbZAXN0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 08:26:09 -0500
Received: from mail.sf-mail.de ([62.27.20.61]:37130 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641AbZAXN0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 08:26:07 -0500
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.29-rc2-git1: Reported regressions 2.6.27 -> 2.6.28
Date: Sat, 24 Jan 2009 14:25:53 +0100
User-Agent: KMail/1.9.10
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Francois Romieu <romieu@fr.zoreil.com>
References: <KTnguC9mFUC.A.VNB.TJRdJB@chimera>
In-Reply-To: <KTnguC9mFUC.A.VNB.TJRdJB@chimera>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3317630.ngOX1hdzps";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200901241426.01027.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3317630.ngOX1hdzps
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Rafael J. Wysocki wrote:
> This message contains a list of some regressions introduced between 2.6.27
> and 2.6.28, for which there are no fixes in the mainline I know of.  If a=
ny
> of them have been fixed already, please let me know.
>
> If you know of any other unresolved regressions introduced between 2.6.27
> and 2.6.28, please let me know either and I'll add them to the list.
> Also, please let me know if any of the entries below are invalid.
>
> Each entry from the list will be sent additionally in an automatic reply =
to
> this message with CCs to the people involved in reporting and handling the
> issue.
>
>
> Listed regressions statistics:
>
>   Date          Total  Pending  Unresolved
>   ----------------------------------------
>   2009-01-20      144       30          27
>   2009-01-11      139       33          30
>   2008-12-21      120       19          17
>   2008-12-13      111       14          13
>   2008-12-07      106       20          17
>   2008-12-04      106       29          21
>   2008-11-22       93       25          15
>   2008-11-16       89       32          18
>   2008-11-09       73       40          27
>   2008-11-02       55       41          29
>   2008-10-25       26       25          20
>
>
> Unresolved regressions
> ----------------------
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D12500
> Subject		: r8169: NETDEV WATCHDOG: eth0 (r8169): transmit timed out
> Submitter	: Justin Piszcz <jpiszcz@lucidpixels.com>
> Date		: 2009-01-13 21:19 (7 days old)
> References	: http://marc.info/?l=3Dlinux-kernel&m=3D123188160811322&w=3D4
> Handled-By	: Francois Romieu <romieu@fr.zoreil.com>

This one, as well as 12411, is likely just a dupe of 10109. r8169 has this=
=20
problem for more than a year.

Greetings,

Eike

--nextPart3317630.ngOX1hdzps
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkl7FugACgkQXKSJPmm5/E4hjACfbDek8Ge/oSd+rHzQIq3S6FYD
8HMAn0r8RiUW2aow6FnzyFw11K10ZX+0
=t6xd
-----END PGP SIGNATURE-----

--nextPart3317630.ngOX1hdzps--
