Return-Path: <linux-kernel-owner+w=401wt.eu-S1751805AbZGaJaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805AbZGaJaf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 05:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbZGaJaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 05:30:35 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:38802 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbZGaJae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 05:30:34 -0400
Date: Fri, 31 Jul 2009 11:30:26 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Pavel Pisa <ppisa@pikron.com>
Subject: Re: [PATCH 26/62] drivers/mmc/host/imxmmc.c: Remove unnecessary
 semicolons
Message-ID: <20090731113026.5e025c94@mjolnir.ossman.eu>
In-Reply-To: <d76aa5b943c6cd92a1a02565c681575ecac48678.1246173681.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
	<d76aa5b943c6cd92a1a02565c681575ecac48678.1246173681.git.joe@perches.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.2; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-1550-1249032631-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-1550-1249032631-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 28 Jun 2009 09:26:31 -0700
Joe Perches <joe@perches.com> wrote:

> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/mmc/host/imxmmc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/mmc/host/imxmmc.c b/drivers/mmc/host/imxmmc.c
> index e0be21a..bf98d7c 100644
> --- a/drivers/mmc/host/imxmmc.c
> +++ b/drivers/mmc/host/imxmmc.c
> @@ -652,7 +652,7 @@ static irqreturn_t imxmci_irq(int irq, void *devid)
>  	set_bit(IMXMCI_PEND_STARTED_b, &host->pending_events);
>  	tasklet_schedule(&host->tasklet);
> =20
> -	return IRQ_RETVAL(handled);;
> +	return IRQ_RETVAL(handled);
>  }
> =20
>  static void imxmci_tasklet_fnc(unsigned long data)

Queued.

--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-1550-1249032631-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkpyubYACgkQ7b8eESbyJLgzsgCfQaF8NsdumsYeU8Avy4ufLclc
K4IAoJO+bH2B64kk8Fp7Ynr9B0eDYR3l
=K2Lv
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-1550-1249032631-0001-2--
