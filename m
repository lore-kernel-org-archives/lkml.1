Return-Path: <linux-kernel-owner+w=401wt.eu-S1754063AbZCJIFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbZCJIFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 04:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753252AbZCJIEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 04:04:46 -0400
Received: from gmp-eb-inf-1.sun.com ([192.18.6.21]:34701 "EHLO
	gmp-eb-inf-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbZCJIEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 04:04:45 -0400
MIME-version: 1.0
Date: Tue, 10 Mar 2009 09:04:19 +0100
From: Frank Mehnert <Frank.Mehnert@Sun.COM>
Subject: Re: remap_pfn_range() not suitable for physical RAM?
In-reply-to: <200903042025.46861.frank.mehnert@sun.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, suresh.b.siddha@intel.com
Message-id: <200903100904.22753.frank.mehnert@sun.com>
Organization: Sun Microsystems
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary=nextPart3251115.IUt3qJTegk
Content-transfer-encoding: 7BIT
References: <200903042025.46861.frank.mehnert@sun.com>
User-Agent: KMail/1.9.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart3251115.IUt3qJTegk
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

sorry for re-posting this message and sorry for addressing you directly.
Perhaps you can help me again or can you give me a pointer for a proper
documentation of the various *remap* and *vm_insert* functions:

On Wednesday 04 March 2009, Frank Mehnert wrote:
> since 2.6.29-rcX it seems to be not allowed anymore to use
> remap_pfn_range() to remap physical RAM to userland. This restriction
> applies only if CONFIG_X86_PAT is enabled. It seems that vm_insert_page()
> does not have this restriction. Am I correct? And what is the reason
> for this restriction?

Kind regards,

=46rank
=2D-=20
Dr.-Ing. Frank Mehnert    Sun Microsystems    http://www.sun.com/

--nextPart3251115.IUt3qJTegk
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkm2HwMACgkQ6z8pigLf3EfwuACfVK+LGpDachLCjdUmhtJoEbrl
i/MAniC8a1VB9eZ20zbWlocGlhkt9Ow2
=a2YC
-----END PGP SIGNATURE-----

--nextPart3251115.IUt3qJTegk--
