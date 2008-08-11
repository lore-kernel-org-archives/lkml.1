Return-Path: <linux-kernel-owner+w=401wt.eu-S1753836AbYHKXjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbYHKXjf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 19:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753692AbYHKXjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 19:39:24 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37931 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755564AbYHKXjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 19:39:23 -0400
Date: Tue, 12 Aug 2008 09:39:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steven French <sfrench@us.ibm.com>
Cc: James Morris <jmorris@namei.org>, "David S. Miller" <davem@davemloft.net>,
       David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Resolved merge conflicts in next-creds
Message-Id: <20080812093911.36bc21d3.sfr@canb.auug.org.au>
In-Reply-To: <OF680EEF56.1C72E960-ON872574A2.005194A0-862574A2.0051B900@us.ibm.com>
References: <alpine.LRH.1.10.0808110950530.3636@tundra.namei.org>
	<OF680EEF56.1C72E960-ON872574A2.005194A0-862574A2.0051B900@us.ibm.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__12_Aug_2008_09_39_11_+1000_33vaMVWTK..Cd3u1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__12_Aug_2008_09_39_11_+1000_33vaMVWTK..Cd3u1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Steve,

On Mon, 11 Aug 2008 09:51:28 -0500 Steven French <sfrench@us.ibm.com> wrote:
>
> These (cifs) changes should be in Linus's mainline now so should be easie=
r=20
> to merge your patch now.

Yeah, the conflicts were no longer in yesterday's linux-next merge.
Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__12_Aug_2008_09_39_11_+1000_33vaMVWTK..Cd3u1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkigzZ8ACgkQjjKRsyhoI8w/bwCdFwsf5X20gzdn9nRUmvWhlKX7
F6QAoJtgpOe6o5/mbEr71km/u/+EWzA4
=Viap
-----END PGP SIGNATURE-----

--Signature=_Tue__12_Aug_2008_09_39_11_+1000_33vaMVWTK..Cd3u1--
