Return-Path: <linux-kernel-owner+w=401wt.eu-S1751993AbZHJX7C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbZHJX7C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 19:59:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750987AbZHJX7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 19:59:00 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38237 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbZHJX67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 19:58:59 -0400
Date: Tue, 11 Aug 2009 09:58:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Eric Paris <eparis@redhat.com>
Cc: James Morris <jmorris@namei.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: security-testing tree build failure
Message-Id: <20090811095854.be242e4f.sfr@canb.auug.org.au>
In-Reply-To: <1249913269.2081.1.camel@dhcp231-106.rdu.redhat.com>
References: <20090807145932.77bc2c98.sfr@canb.auug.org.au>
	<1249913269.2081.1.camel@dhcp231-106.rdu.redhat.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__11_Aug_2009_09_58_54_+1000_Z8E=hSJiR1e0oOD3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__11_Aug_2009_09_58_54_+1000_Z8E=hSJiR1e0oOD3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

HI Eric,


On Mon, 10 Aug 2009 10:07:49 -0400 Eric Paris <eparis@redhat.com> wrote:
>
> Sorry, I thought I put the definitions outside of the ifdef in
> security.h but clearly they aren't.  Looks like James's tree has the fix
> as of a couple of hours ago, so you should be fix on your next pull from
> him.

Great, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__11_Aug_2009_09_58_54_+1000_Z8E=hSJiR1e0oOD3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqAtD4ACgkQjjKRsyhoI8wg/QCeNF/4wRiTPWDi0AWPZtHbgQNc
SmkAmwemsgantaHA4WEMzg67lIj3ei1X
=gkSy
-----END PGP SIGNATURE-----

--Signature=_Tue__11_Aug_2009_09_58_54_+1000_Z8E=hSJiR1e0oOD3--
