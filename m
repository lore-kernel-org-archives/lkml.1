Return-Path: <linux-kernel-owner+w=401wt.eu-S1753799AbZHKNR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799AbZHKNR6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 09:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbZHKNR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 09:17:57 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:47456 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbZHKNR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 09:17:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=yCA6OB4JvdgZmkGujjAvcdgR30Hs4Qr1HA7QPTqMh734s7YRlkIEDe46sfiDL5BwJL
         jIPKHJO4qGyKlTZ7aORVJ2MieRKQJhyC6LpyALPs9bA2cduSAwC9N5g548TeyJiejzLt
         ae6e+xFj9dTX4kphwoQQfzBTqXbfTiYZEeK9s=
From: Florian Fainelli <florian@openwrt.org>
To: Wim Van Sebroeck <wim@iguana.be>
Subject: Re: [PATCH 7/8] ar7_wdt: fix path to ar7 header files
Date: Tue, 11 Aug 2009 15:17:51 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200906041620.39752.florian@openwrt.org> <20090605070517.GB21360@infomag.iguana.be>
In-Reply-To: <20090605070517.GB21360@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2213249.ve5L9qEj2C";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200908111517.54100.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2213249.ve5L9qEj2C
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Le Friday 05 June 2009 09:05:17 Wim Van Sebroeck, vous avez =E9crit=A0:
> > While resubmitting AR7, we changed the machine specific
> > headers from ar7 to mach-ar7, fix the watchdog driver
> > accordingly.
> >
> > Signed-off-by: Florian Fainelli <florian@openwrt.org>
>
> Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Wim, can you apply this one to your tree if not done already, otherwise it=
=20
will cause a build failure in 2.6.31. Thanks !
=2D-=20
Best regards, Florian Fainelli
Email: florian@openwrt.org
Web: http://openwrt.org
IRC: [florian] on irc.freenode.net
=2D------------------------------

--nextPart2213249.ve5L9qEj2C
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkqBb4AACgkQlyvkmBGtjyZ/PQCgoGTwg33gv/jmhK5LyDXnaTNg
G7cAnjII+gohTOrq5neo0Gr0fbo3VvAn
=wSDo
-----END PGP SIGNATURE-----

--nextPart2213249.ve5L9qEj2C--
