Return-Path: <linux-kernel-owner+w=401wt.eu-S1757381AbYB2CAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381AbYB2CAf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 21:00:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558AbYB2CA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 21:00:26 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:51293 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309AbYB2CAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 21:00:25 -0500
Date: Fri, 29 Feb 2008 13:00:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Matthew Wilcox <willy@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@osdl.org>,
       linux-next@vger.kernel.org, Linus <torvalds@linux-foundation.org>
Subject: Re: [PATCH 11/12] Generic semaphore implementation
Message-Id: <20080229130019.3ede8053.sfr@canb.auug.org.au>
In-Reply-To: <20080229003954.GA525@parisc-linux.org>
References: <1204180441-8540-3-git-send-email-matthew@wil.cx>
	<1204180441-8540-4-git-send-email-matthew@wil.cx>
	<1204180441-8540-5-git-send-email-matthew@wil.cx>
	<1204180441-8540-6-git-send-email-matthew@wil.cx>
	<1204180441-8540-7-git-send-email-matthew@wil.cx>
	<1204180441-8540-8-git-send-email-matthew@wil.cx>
	<1204180441-8540-9-git-send-email-matthew@wil.cx>
	<1204180441-8540-10-git-send-email-matthew@wil.cx>
	<1204180441-8540-11-git-send-email-matthew@wil.cx>
	<20080228071822.GA13571@elte.hu>
	<20080229003954.GA525@parisc-linux.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__29_Feb_2008_13_00_19_+1100_IXTD1j0jxA8JAmtW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__29_Feb_2008_13_00_19_+1100_IXTD1j0jxA8JAmtW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 28 Feb 2008 17:39:54 -0700 Matthew Wilcox <matthew@wil.cx> wrote:
>
> Stephen, I've put the semaphore patches into a git tree; can you add it
> to linux-next?
>=20
> http://git.kernel.org/?p=3Dlinux/kernel/git/willy/misc.git;a=3Dshortlog;h=
=3Dsemaphore

I have put this in for toady's build (but using the git URL).  This tree
is in the "too many conflicts and its out until fixed" category ...
However, it is also a candidate for Linus' "next" branch (if he is going
to run one ...).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__29_Feb_2008_13_00_19_+1100_IXTD1j0jxA8JAmtW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHx2c4TgG2atn1QN8RAn6/AJwPb43lGhng72FdId7tGDxAboCwcQCcCsNR
W6aCB7SLZOUSuz5sc2SpDEg=
=ehA/
-----END PGP SIGNATURE-----

--Signature=_Fri__29_Feb_2008_13_00_19_+1100_IXTD1j0jxA8JAmtW--
