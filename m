Return-Path: <linux-kernel-owner+w=401wt.eu-S1754339AbZJYWrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339AbZJYWrn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 18:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754224AbZJYWrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 18:47:42 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58974 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754181AbZJYWrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 18:47:41 -0400
Date: Mon, 26 Oct 2009 09:47:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-next@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       Eric Paris <eparis@parisplace.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: writable limits to -next [was: Adding to linux-next?]
Message-Id: <20091026094741.5a1d492c.sfr@canb.auug.org.au>
In-Reply-To: <4AE16B0A.7020400@gmail.com>
References: <4AC6339B.7000905@gmail.com>
	<20091006225751.7d5f3eec.sfr@canb.auug.org.au>
	<4AE16B0A.7020400@gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__26_Oct_2009_09_47_41_+1100_hrU=pX7iLu20PEKY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__26_Oct_2009_09_47_41_+1100_hrU=pX7iLu20PEKY
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

On Fri, 23 Oct 2009 10:36:26 +0200 Jiri Slaby <jirislaby@gmail.com> wrote:
>
> Hi, could you please add git://decibel.fi.muni.cz/~xslaby/linux#limits
> into the -next tree?

I have added it from today.

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
	Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

Legal Stuff:
By participating in linux-next, your subsystem tree contributions are
public and will be included in the linux-next trees.  You may be sent
e-mail messages indicating errors or other issues when the
patches/commits from your subsystem tree are merged and tested in
linux-next.  These messages may also be cross-posted to the linux-next
mailing list, the linux-kernel mailing list, etc.  The linux-next tree
project and IBM (my employer) make no warranties regarding the linux-next
project, the testing procedures, the results, the e-mails, etc.  If you
don't agree to these ground rules, let me know and I'll remove your tree
from participation in linux-next.

--Signature=_Mon__26_Oct_2009_09_47_41_+1100_hrU=pX7iLu20PEKY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrk1Y0ACgkQjjKRsyhoI8xX7gCfcVYYxehwLxQw/WLvATw1Zcn5
f/8An3zlgEZ1nBjaCon6K+Rb7eifPmzf
=ADPC
-----END PGP SIGNATURE-----

--Signature=_Mon__26_Oct_2009_09_47_41_+1100_hrU=pX7iLu20PEKY--
