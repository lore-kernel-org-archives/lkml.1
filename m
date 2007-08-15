Return-Path: <linux-kernel-owner+w=401wt.eu-S1765339AbXHOOuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765339AbXHOOuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 10:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762539AbXHOOuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 10:50:12 -0400
Received: from iucha.net ([209.98.146.184]:34844 "EHLO mail.iucha.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932231AbXHOOuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 10:50:07 -0400
Date: Wed, 15 Aug 2007 09:50:06 -0500
From: Florin Iucha <florin@iucha.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Tejun Heo <htejun@gmail.com>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [linux-usb-devel] USB-related oops in sysfs with linux
	v2.6.23-rc3-50-g28e8351
Message-ID: <20070815145005.GB7124@iucha.net>
References: <20070815133147.GA7124@iucha.net> <Pine.LNX.4.44L0.0708151033270.3895-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1LKvkjL3sHcu1TtY"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0708151033270.3895-100000@iolanthe.rowland.org>
X-GPG-Key: http://iucha.net/florin_iucha.gpg
X-GPG-Fingerprint: 5E59 C2E7 941E B592 3BA4  7DCF 343D 2B14 2376 6F5B
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--1LKvkjL3sHcu1TtY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 15, 2007 at 10:38:54AM -0400, Alan Stern wrote:
> This patch will get rid of the annoying error messages.  It won't do=20
> anything about your keyboard's tendency to spontaneously stop working,=20
> alas.

My keyboard works fine for days, with kernels up to and including
2.6.23-rc2 . I have booted into 2.6.23-rc3-$whatever this morning, and
after 10-15 minutes the keyboard stopped working.  The mice which were
plugged in the keyboard's built-in hub were fine though.

The first time it happened, I removed the keyboard and got the oops
that started this thread.  The second time, I just logged-in remotely
and rebooted, and the reboot process stopped at "KILLING all
processes" step.  I simply reset the box and rebooted into 2.6.23-rc2
and it is fine since (over an hour ago).

Regards,
florin

--=20
Bruce Schneier expects the Spanish Inquisition.
      http://geekz.co.uk/schneierfacts/fact/163

--1LKvkjL3sHcu1TtY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGwxKdND0rFCN2b1sRArHlAJ9/mo8hcA+2nhOjOqZRb4zcZjPw5ACeMR9A
QHqX6FAvnLDkklDZ2IT83zU=
=eP9A
-----END PGP SIGNATURE-----

--1LKvkjL3sHcu1TtY--
