Return-Path: <linux-kernel-owner+w=401wt.eu-S1754591AbZLRAmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbZLRAmd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 19:42:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753750AbZLRAmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 19:42:31 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:42660 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292AbZLRAma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 19:42:30 -0500
Date: Fri, 18 Dec 2009 11:42:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <gregkh@suse.de>
Cc: Phil Carmody <ext-phil.2.carmody@nokia.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/6] Driver core: Encourage use of const attributes
Message-Id: <20091218114223.ca328c28.sfr@canb.auug.org.au>
In-Reply-To: <20091217231621.GA5103@suse.de>
References: <1261073536-27396-1-git-send-email-ext-phil.2.carmody@nokia.com>
	<20091217231621.GA5103@suse.de>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__18_Dec_2009_11_42_23_+1100_+U0QNyZtl6PxmQ73"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__18_Dec_2009_11_42_23_+1100_+U0QNyZtl6PxmQ73
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Thu, 17 Dec 2009 15:16:21 -0800 Greg KH <gregkh@suse.de> wrote:
>
> I'll be glad to take 1-3 now, and queue it up for .34.

Any reason not to ask Linus to take them for .33 - that way the
conversions of callers can be done adhoc (and in more than just your
tree) for .34.  These API changes should be perfectly safe (and the
compiler should tell us if they are not).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__18_Dec_2009_11_42_23_+1100_+U0QNyZtl6PxmQ73
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksqz+8ACgkQjjKRsyhoI8yazgCgo334hGvjjxnJpWTrhyrxyE3Q
Ix0An1KxhYPfskY+8Nz+Vftm5yHV1/jP
=Kmrm
-----END PGP SIGNATURE-----

--Signature=_Fri__18_Dec_2009_11_42_23_+1100_+U0QNyZtl6PxmQ73--
