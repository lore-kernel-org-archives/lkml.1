Return-Path: <linux-kernel-owner+w=401wt.eu-S932443AbYBNHpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443AbYBNHpT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 02:45:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758776AbYBNHpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 02:45:03 -0500
Received: from ns1.suse.de ([195.135.220.2]:40159 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758111AbYBNHpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 02:45:00 -0500
From: Andreas Jaeger <aj@suse.de>
To: Greg KH <greg@kroah.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, muli@il.ibm.com,
       discuss@x86-64.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, jdmason@kudzu.us,
       linux-pci@atrey.karlin.mff.cuni.cz, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [discuss] pci_get_device_reverse(), why does Calgary need this?
References: <20080213001506.GA13933@kroah.com> <20080213021737.72b9815d@core>
	<20080213044536.GC10101@kroah.com>
	<200802131334.12351.bzolnier@gmail.com>
	<20080213172824.GB10733@kroah.com> <20080213181655.GB8960@kroah.com>
OpenPGP: id=C272A126; url=http://www.suse.de/~aj/keys.txt
Mail-Followup-To: Greg KH <greg@kroah.com>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, muli@il.ibm.com,
	discuss@x86-64.org, linux-kernel@vger.kernel.org,
	linux-ide@vger.kernel.org, jdmason@kudzu.us,
	linux-pci@atrey.karlin.mff.cuni.cz,
	Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Thu, 14 Feb 2008 08:44:56 +0100
In-Reply-To: <20080213181655.GB8960@kroah.com> (Greg KH's message of "Wed, 13
	Feb 2008 10:16:55 -0800")
Message-ID: <ho3arwq8w7.fsf@reger.suse.de>
User-Agent: Gnus/5.110007 (No Gnus v0.7) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

Greg KH <greg@kroah.com> writes:

> How does the patch below look?  I didn't want to remove the whole config
> option, as there is more to the logic than just the "reverse order"
> stuff there.

I think you miss Documentation - it's mentioned in ide.txt and
kernel-parameters.txt,

Andreas
=2D-=20
 Andreas Jaeger, Director Platform / openSUSE, aj@suse.de
  SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
   Maxfeldstr. 5, 90409 N=FCrnberg, Germany
    GPG fingerprint =3D 93A3 365E CE47 B889 DF7F  FED1 389A 563C C272 A126

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQFHs/F4OJpWPMJyoSYRAkmaAJ98FDBrEqgchU6Inns7ibejVMarRwCcDGD9
z/1oDVda428hbN8Jolro2/4=
=uc6p
-----END PGP SIGNATURE-----
--=-=-=--
