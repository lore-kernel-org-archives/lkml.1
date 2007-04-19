Return-Path: <linux-kernel-owner+w=401wt.eu-S1766760AbXDSPrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766760AbXDSPrp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 11:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766822AbXDSPrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 11:47:45 -0400
Received: from lug-owl.de ([195.71.106.12]:32770 "EHLO lug-owl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766760AbXDSPro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 11:47:44 -0400
Date: Thu, 19 Apr 2007 17:47:43 +0200
From: Jan-Benedict Glaw <jbglaw@lug-owl.de>
To: Dan Aloni <da-x@monatomic.org>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org
Subject: Re: [PATCH] add two SCSI command opcodes
Message-ID: <20070419154743.GA18325@lug-owl.de>
Mail-Followup-To: Dan Aloni <da-x@monatomic.org>,
	Linux Kernel List <linux-kernel@vger.kernel.org>,
	linux-scsi@vger.kernel.org
References: <20070419151053.GA10199@localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
In-Reply-To: <20070419151053.GA10199@localdomain>
X-Operating-System: Linux mail 2.6.12.3lug-owl 
X-gpg-fingerprint: 250D 3BCF 7127 0D8C A444  A961 1DBD 5E75 8399 E1BB
X-gpg-key: wwwkeys.de.pgp.net
X-Echelon-Enable: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
X-TKUeV: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-04-19 18:10:54 +0300, Dan Aloni <da-x@monatomic.org> wrote:
> diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
> index 5c0e979..dff842a 100644
> --- a/include/scsi/scsi.h
> +++ b/include/scsi/scsi.h
> @@ -103,6 +103,7 @@ extern const unsigned char scsi_command_size[8];
>  #define READ_12               0xa8
>  #define WRITE_12              0xaa
>  #define WRITE_VERIFY_12       0xae
> +#define VERIFY_12             0xaf
>  #define SEARCH_HIGH_12        0xb0
>  #define SEARCH_EQUAL_12       0xb1
>  #define SEARCH_LOW_12         0xb2
> @@ -111,6 +112,7 @@ extern const unsigned char scsi_command_size[8];
>  #define WRITE_LONG_2          0xea
>  #define READ_16               0x88
>  #define WRITE_16              0x8a
> +#define WRITE_VERIFY_16       0x8e
>  #define VERIFY_16	      0x8f
>  #define SERVICE_ACTION_IN     0x9e
>  /* values for service action in */

Where's the user?

MfG, JBG

--=20
      Jan-Benedict Glaw      jbglaw@lug-owl.de              +49-172-7608481
  Signature of:                          Zensur im Internet? Nein danke!
  the second  :

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGJ48fHb1edYOZ4bsRAru2AJ0WB/UbLueFiJcRZAET/XrpYFt7yACdGyAx
hKrW2X2BOfbJvvX6cmb/YHc=
=IV2Q
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
