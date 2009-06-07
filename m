Return-Path: <linux-kernel-owner+w=401wt.eu-S1753676AbZFGNuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676AbZFGNuN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 09:50:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752444AbZFGNuC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 09:50:02 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:58895 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbZFGNuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 09:50:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type;
        b=nZRlLFE0WiueTwqIucRLwKu/k3NaIKJAS2VjYIjJZQgA4s10HXRBwwD9fI6vLuVgSc
         0U5O3TVAub83cAQdZZn9wcTFBQMIvaQc8Hrd9oX1k73VHxQlp2Kv0XANQnWmbAI1+Lv9
         rbzOi8KhwsEoEsz802udq1aHnC2V5Firrx5eM=
Date: Sun, 7 Jun 2009 16:50:18 +0300
From: Sergei Trofimovich <slyich@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #13294] i915: drm: xorg leaks drm objects massively
Message-ID: <20090607165018.4c946a30@mosly.slynet.org>
In-Reply-To: <AN6kEAA5GQ.A.obB.3j7KKB@chimera>
References: <sIiXQlfwS3D.A.81.dj7KKB@chimera>
	<AN6kEAA5GQ.A.obB.3j7KKB@chimera>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/cGk7KZV8R6kUukqT8Rx.IM8";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/cGk7KZV8R6kUukqT8Rx.IM8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun,  7 Jun 2009 12:06:23 +0200 (CEST)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.28 and 2.6.29.
>=20
> The following bug entry is on the current list of known regressions
> introduced between 2.6.28 and 2.6.29.  Please verify if it still should
> be listed and let me know (either way).
>=20
>=20
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D13294
> Subject		: i915: drm: xorg leaks drm objects massively
> Submitter	: Sergei Trofimovich <slyich@gmail.com>
> Date		: 2009-05-10 19:56 (29 days old)
> References	: http://marc.info/?l=3Dlinux-kernel&m=3D124198547027903&w=3D4
>=20
>=20
Rafael, please remove it from regression list. I haven't found kernel worki=
ng
the other way. It's a bug(set of bugs) being around "forever". Many people
confirm it on various laptops/kernel versions. It's just not very noticeabl=
e.

--=20

  Sergei

--Sig_/cGk7KZV8R6kUukqT8Rx.IM8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkorxZ8ACgkQcaHudmEf86pyQwCcD710e6QU+3zEgH9MVZCeXd1r
rdcAn1p1WXqOpQENAwCGQShJ+Ct7kvAH
=3JZP
-----END PGP SIGNATURE-----

--Sig_/cGk7KZV8R6kUukqT8Rx.IM8--
