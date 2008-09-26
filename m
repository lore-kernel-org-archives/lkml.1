Return-Path: <linux-kernel-owner+w=401wt.eu-S1753932AbYIZKvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbYIZKvS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 06:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbYIZKvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 06:51:07 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:38543 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbYIZKvG (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 06:51:06 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org
Subject: Re: CONFIG_SECURITY_ROOTPLUG [was: Re: 2.6.27-rc7 no init found on the root partition?]
In-Reply-To: Your message of "Fri, 26 Sep 2008 12:05:07 +0200."
             <20080926100507.GR31582@ics.muni.cz>
From: Valdis.Kletnieks@vt.edu
References: <20080925165400.GQ31582@ics.muni.cz> <20080926024927.GA13816@hallyn.com>
            <20080926100507.GR31582@ics.muni.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1222426244_7097P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 26 Sep 2008 06:50:44 -0400
Message-ID: <30625.1222426244@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1222426244_7097P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri, 26 Sep 2008 12:05:07 +0200, Lukas Hejtmanek said:
> On Thu, Sep 25, 2008 at 09:49:27PM -0500, Serge E. Hallyn wrote:
> > Hmm, is there a difference in the device drivers such that root_plug =
simply
> > isn't able to find the usb 'key' in 2.6.27-rc7?
> >=20
> > When you boot with CONFIG_SECURITY_ROOTPLUG=3Dn, can you read the usb=
 key?
>=20
> I do not have USB key at all. So maybe there is a security bug in 2.6.2=
6.3?

It must be a bug in 26.3 - if you don't have the proper USB dongle/key/wh=
atever
inserted, it shouldn't have come up.

--==_Exmh_1222426244_7097P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFI3L6EcC3lWbTT17ARAmRSAJ4p7tObAI7evbX/thiCIbp+EwVaUwCaAtGf
Y8AeXblAFQB1C56XAtca9mo=
=MYDG
-----END PGP SIGNATURE-----

--==_Exmh_1222426244_7097P--
