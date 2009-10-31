Return-Path: <linux-kernel-owner+w=401wt.eu-S1751240AbZJaEXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751240AbZJaEXx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 00:23:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750740AbZJaEXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 00:23:50 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55784 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715AbZJaEXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 00:23:50 -0400
Date: Sat, 31 Oct 2009 15:23:47 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>
Subject: Re: linux-next: manual merge of the percpu tree with Linus' tree
Message-Id: <20091031152347.12ee46fa.sfr@canb.auug.org.au>
In-Reply-To: <4AEAB9B1.4000304@kernel.org>
References: <20091030192050.06a0f706.sfr@canb.auug.org.au>
	<4AEAB9B1.4000304@kernel.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__31_Oct_2009_15_23_47_+1100_Se45z0q/lxxm6XJm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__31_Oct_2009_15_23_47_+1100_Se45z0q/lxxm6XJm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

HI Tejun,

On Fri, 30 Oct 2009 11:02:25 +0100 Tejun Heo <tj@kernel.org> wrote:
>
> I'll pull master into for-next in a few days so that we can do sparse
> cleanup pass over the whole tree on the latest tree.

Great, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__31_Oct_2009_15_23_47_+1100_Se45z0q/lxxm6XJm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrru9MACgkQjjKRsyhoI8wqJQCfbfDJvvuVKpgINBGqYjD9larh
Iw4AoJznKITg9TAC5Z4xMUbHueADRQWT
=tIn9
-----END PGP SIGNATURE-----

--Signature=_Sat__31_Oct_2009_15_23_47_+1100_Se45z0q/lxxm6XJm--
