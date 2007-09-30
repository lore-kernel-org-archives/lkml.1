Return-Path: <linux-kernel-owner+w=401wt.eu-S1753361AbXI3WAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbXI3WAv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 18:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbXI3WAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 18:00:44 -0400
Received: from os.inf.tu-dresden.de ([141.76.48.99]:59942 "EHLO
	os.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbXI3WAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 18:00:43 -0400
Date: Mon, 1 Oct 2007 00:00:37 +0200
From: "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>
To: Frans Pop <elendil@planet.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [2.6.23-rc8-mm2] System hangs (loops?) during boot
Message-ID: <20071001000037.475473bd@laptop.hypervisor.org>
In-Reply-To: <200709302350.30612.elendil@planet.nl>
References: <200709282225.21530.elendil@planet.nl>
	<20070929130234.e5f0f777.akpm@linux-foundation.org>
	<20070930154424.68e4218e@laptop.hypervisor.org>
	<200709302350.30612.elendil@planet.nl>
X-Mailer: X-Mailer 5.0 Gold
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/BGkjhSqaQNXMb+C8LlTUGjX";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/BGkjhSqaQNXMb+C8LlTUGjX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 30 Sep 2007 23:50:29 +0200 Frans Pop (FP) wrote:

FP> I'm not sure what you mean. I fetched the branch I think you referred t=
o=20
FP> [1], but when I did a merge of that on top of v2.6.23-rc8-mm2 I=20
FP> got "Already up-to-date", so AFAICT that branch is fully merged into mm
FP> and I'm already running with you latest code...
FP> Please correct me if I'm doing anything wrong.

I was suggesting to download 2.6.23-rc8 and applying the -hrt patchset at
http://www.kernel.org/pub/linux/kernel/people/tglx/hrtimers/2.6.23-rc8/
on top of it.

That excludes all the extra stuff in -mm and should give us a good hint
whether HPET is really at fault.

Cheers,

	- Udo

--Sig_/BGkjhSqaQNXMb+C8LlTUGjX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHAByFnhRzXSM7nSkRAhKEAJwKTcSXw9qTra6U9ALKgLQhjEZG3wCeL4hx
VNyK9bLfKDlVNe3hAgqWuI4=
=d6pw
-----END PGP SIGNATURE-----

--Sig_/BGkjhSqaQNXMb+C8LlTUGjX--
