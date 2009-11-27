Return-Path: <linux-kernel-owner+w=401wt.eu-S1754192AbZK0JYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbZK0JYN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 04:24:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754166AbZK0JYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 04:24:12 -0500
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3504 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158AbZK0JYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 04:24:11 -0500
X-Greylist: delayed 511 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Nov 2009 04:24:11 EST
Date: Fri, 27 Nov 2009 10:15:29 +0100
From: Erik Mouw <mouw@nl.linux.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: remove docbook and example
Message-ID: <20091127101529.63b2baa5@nij0285>
In-Reply-To: <20091127070331.GF26327@x200.malnet.ru>
References: <20091127070331.GF26327@x200.malnet.ru>
Organization: Eric Conspiracy Secret Labs
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Pv+wi/m2+PKm5QfJ1ypG7un"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Pv+wi/m2+PKm5QfJ1ypG7un
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 27 Nov 2009 10:03:31 +0300
Alexey Dobriyan <adobriyan@gmail.com> wrote:
> Example is outdated, it still uses old ->read_proc interfaces and
> "fb" example is plain racy.
> There are better examples all over the tree.

Agreed, it was written back in the early 2.4 days. Time moves on.

> Docbook itself says almost nothing about /proc
> and contain quite a number of simply wrong facts, e.g. device nodes
> support. What it does is describing at great length interface which
> are going to be removed.

I always had plans to update the documentation but never could set
myself to do it.

> There are Documentation/filesystems/seq_file.txt in exchange.

Great, updated/newer documentation. Just remove the procfs
documentation and examples.

> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Erik Mouw <mouw@nl.linux.org>


Regards,

Erik

--=20
Erik Mouw -- mouw@nl.linux.org
GPG key fingerprint: D6AC 7F15 A26E C5C4 62E0  4A58 FCF9 551C 9B48 B68D

--Sig_/Pv+wi/m2+PKm5QfJ1ypG7un
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAksPmLEACgkQ/PlVHJtIto3yQACeN9BvoO6smVrw5hSyFlR6wWzj
kcYAoITjjWPGmmzu0wQ+ikpC3oqC4mnz
=O9cS
-----END PGP SIGNATURE-----

--Sig_/Pv+wi/m2+PKm5QfJ1ypG7un--
