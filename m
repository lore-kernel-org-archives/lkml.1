Return-Path: <linux-kernel-owner+w=401wt.eu-S1161368AbXEDTLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161368AbXEDTLA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 15:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161894AbXEDTLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 15:11:00 -0400
Received: from ironport2.mynow.co.uk ([81.91.192.236]:49063 "EHLO
	ironport2.mynow.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161368AbXEDTK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 15:10:58 -0400
X-Greylist: delayed 661 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 May 2007 15:10:58 EDT
X-BrightmailFiltered: true
From: "David J. Wallace" <katana@onetel.com>
To: ck@vds.kolivas.org
Subject: Re: [ck] 2.6.21-ck1
Date: Fri, 4 May 2007 19:59:41 +0100
User-Agent: KMail/1.8.2
Cc: Con Kolivas <kernel@kolivas.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
References: <200705042301.01305.kernel@kolivas.org>
In-Reply-To: <200705042301.01305.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3322948.ejAd9zrHme";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705041959.47686.katana@onetel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3322948.ejAd9zrHme
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 04 May 2007 14:00, Con Kolivas wrote:
> This patchset is designed to improve system responsiveness and
> interactivity. It is configurable to any workload but the default -ck pat=
ch
> is aimed at the desktop and -cks is available with more emphasis on
> serverspace.

Hi Con,=20

I have 2.6.21-ck1 running happily on a variety of machines. Everything seem=
s=20
fine on both uniprocessor and SMP machines.=20

I've been running SD for a couple of weeks now, including alternating betwe=
en=20
a SD patched kernel and an "old" staircase based kernel for a week of that.=
=20
SD seems perfectly smooth. In fact on going back to the old kernel for a da=
y=20
I'm sure it felt more "choppy". I don't really do benchmarks, "feel" is mor=
e=20
relevant to me. Right now I'd say my R4 "feels" better with SD than it has=
=20
for a long time. Nice Job. Thanks for persisiting.

As an aside I realized whilst trying non ck kernels the last few weeks just=
=20
how much of a difference swap prefetch actually makes on a lowish memory=20
machine such as this.

Arigatou gozaimashita

David

--nextPart3322948.ejAd9zrHme
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGO4KdKsvwCXwmAPgRAlIPAJ9+0wbs/hftk6W0hRgguTtGmHGRcwCbBq2M
rnsqV2tTSAqsdam2FQQf/cA=
=pkOr
-----END PGP SIGNATURE-----

--nextPart3322948.ejAd9zrHme--
