Return-Path: <linux-kernel-owner+w=401wt.eu-S1755371AbYC2IF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbYC2IF2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 04:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752940AbYC2IFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 04:05:04 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:53561 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752728AbYC2IFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 04:05:00 -0400
Date: Sat, 29 Mar 2008 09:04:34 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: "Tomas Winkler" <tomasw@gmail.com>
Cc: linux-kernel@vger.kernel.org, benzizbit@gmail.com
Subject: Re: SDIO: IO-Ready Bit
Message-ID: <20080329090434.7bfb7509@mjolnir.drzeus.cx>
In-Reply-To: <1ba2fa240803240741n5bf042c2j4aaa4d2f70cf8ef@mail.gmail.com>
References: <1ba2fa240803180400y1d7a2740t2c21b8b73a755016@mail.gmail.com>
	<20080318123325.0843b854@mjolnir.drzeus.cx>
	<1ba2fa240803181043v511df0b6tbe43174feb2f7537@mail.gmail.com>
	<20080318192018.1815fd57@mjolnir.drzeus.cx>
	<1ba2fa240803221510n8d5800ft32e0ffa179542aba@mail.gmail.com>
	<20080324145352.6262788b@mjolnir.drzeus.cx>
	<1ba2fa240803240741n5bf042c2j4aaa4d2f70cf8ef@mail.gmail.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAMAAABg3Am1AAAAAXNSR0IArs4c6QAAADNQTFRFEgwFRSofeTwxZEI1h1lFl1ZHeGBetHZk24VzuZJ43p2GsbKw/Lmg2MTL/NO3/+/Q//fpWFujUwAAAk5JREFUSMeNlVcWnDAMRd0bLux/tVGxiAEzic7hZ+Zd1IU6NtbYdn8daic/cgj52CPqLQ8hOBdjzsD8G2hHsCiPBS2/nTyABi93zvsYUyql1v6KSz30AeUAJLAK1uuDUI94WA7GDsAePtRDfwFRgP7DA8vvwOgQ1R5oYQUKAwOsfwDHDcAcWH+e5xagiooey1SwSAy0L8C7BaDKdgKWoNQtIjYEfHQGzMcKwNgCpLdgBn14ZzXNSPkJWK201vjiHMkXZg7AuQWCA7G2DPTiMSIsLSZxbgEIwlqEjE+9WBu0yaWOHwDLLQE9WmMieCBgtG1IAFgBzo7tlojGtbI3wFljuU4JdL3ghPeO+tFr2QHG0DOBSuN0kofaU302zmKbcTrgAWDUywG0OvXELi6gZScAdq6WnhYgvYDGu0YQjYSZs3ROID0B4y+jjpWyAhjePWkAjKwD5o09xioNBoro/+YQZjzTg8ce1CJtwFvwAMDFBEjv6cgI0P/u0DqtGJOjNSAm4e0jABxsgDYXSADQw2wwsFyzdePCAviE48QexseKNiGcp4jgKNEVAGC7QEwY5+S6Qpf50NzujHrdYgEKH0o8ZJ/AQR8HAGiaugDjG2i4ddZx4wToPwB0gQsEfjyFRKf1M+kLQC8u5iuoX8BhxYCQJPZXQ7LQdDnQR87/BdCpQQSJpREh7EMSQOvpYwJaqbAHgrUXkWehxhmUUjpsQ+IDSHlzEvidywrtDYSpnHVioNbstBLi9o3Dn/WqZ3Nw1pUQy8bN3/QdiPiVUZfpP4cDVEKd2cXEAAAAAElFTkSuQmCC
X-Face: @{|$W51qEixc&6}dq_38NM^&.vv|'{O)ae?DMZ1%VYxuhN2}5VpQ!'gx[{V+8Xw'+cV5*491_)-SU2YT8s@4`H;@:ELS'/P(@.JxxJi/C8mG0H#A^R<JfS_l?/%fD\D/mFJ8c2M?_kIL;:txa"s`0O*d+}p/4;$lAw@/e&h-nvQ)~q-a("De+&~-{5`:T{9d%0
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_hera.drzeus.cx-11861-1206777897-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-11861-1206777897-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 24 Mar 2008 16:41:25 +0200
"Tomas Winkler" <tomasw@gmail.com> wrote:

>=20
> Anyhow I've seen that concept of parallel probe is not so new. It was
> in 2.6.18 and removed in 2.619.
> Probably different approach, maybe more would be adding a parallel
> initial function.
> Probe will just register to the bus and relevant subsystem, it will be fa=
st.
> Optional Initialization function will run after probe in different
> thread, this would be the place for running FW download.
> Device won't be considered initialized till this function haven't
> completed or is not implemented.
>=20

I would suspect that would just slow things down in most cases. Most
busses have shared bandwidth, so letting each device take turns is
usually faster than a thundering herd.

Feel free to make your case to the device core maintainers though.

Rgds
Pierre

--=_hera.drzeus.cx-11861-1206777897-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkft+BUACgkQ7b8eESbyJLg+xQCfazhtoFd0vs77EBBtwedBIYrK
zHgAniojt8A1oiGAk27F9wJp7seZV9V0
=Hfut
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-11861-1206777897-0001-2--
