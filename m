Return-Path: <linux-kernel-owner+w=401wt.eu-S1754656AbZDNAM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbZDNAM4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 20:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752996AbZDNAMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 20:12:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47398 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752257AbZDNAMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 20:12:45 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
       Darren Salt <linux@youmustbejoking.demon.co.uk>
In-Reply-To: <20090413024445.GA12860@suse.de>
References: <1239589992.18110.117.camel@deadeye.i.decadent.org.uk>
	 <20090413024445.GA12860@suse.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0Z67h2ckltUNE6OVeoEV"
Date: Tue, 14 Apr 2009 01:12:41 +0100
Message-Id: <1239667961.18110.166.camel@deadeye.i.decadent.org.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
X-SA-Exim-Connect-IP: 192.168.4.182
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [PATCH 0/3] Fix rt28{6,7}0sta to use firmware loader
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-0Z67h2ckltUNE6OVeoEV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-04-12 at 19:44 -0700, Greg KH wrote:
> On Mon, Apr 13, 2009 at 03:33:12AM +0100, Ben Hutchings wrote:
> > Greg,
> >=20
> > The Ralink drivers rt2860sta, rt2870sta and rt3070sta contain non-free
> > firmware which should be distributed separately.
>=20
> Where is it now distributed?  I don't want to break people's machines
> that were working before this patch is applied.

The canonical source is
<http://www.ralinktech.com/ralink/Home/Support/Linux.html>

The files are now also in the Debian repository for our firmware-nonfree
package and in <http://git.decadent.org.uk/git/linux-firmware.git>.
I've asked David Woodhouse to pull from that into his linux-firmware.git
so that they get into other distros.

Ben.


--=-0Z67h2ckltUNE6OVeoEV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBJ49T479ZNCRIGYgcRAifDAJ95YRovOgmmH7VmxWr9T5UtDB097wCdFqop
x4y9OwyoXESY3osT66/9TTE=
=y3Q5
-----END PGP SIGNATURE-----

--=-0Z67h2ckltUNE6OVeoEV--
