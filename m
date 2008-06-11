Return-Path: <linux-kernel-owner+w=401wt.eu-S1762438AbYFKPtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762438AbYFKPtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 11:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761842AbYFKPt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 11:49:28 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:35283 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759545AbYFKPt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 11:49:27 -0400
From: Dan Smith <danms@us.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Paul Menage <menage@google.com>,
       Linux Containers <containers@lists.osdl.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] cgroup_clone: use pid of newly created task for new cgroup
References: <20080610212302.GA1946@us.ibm.com>
	<87ve0ggi2k.fsf@caffeine.beaverton.ibm.com>
	<20080611154637.GB23134@us.ibm.com>
Date: Wed, 11 Jun 2008 08:49:00 -0700
In-Reply-To: <20080611154637.GB23134@us.ibm.com> (Serge E. Hallyn's message of
	"Wed, 11 Jun 2008 10:46:37 -0500")
Message-ID: <87mylsgefn.fsf@caffeine.beaverton.ibm.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

SH> Cool, thanks Dan, I'll add a Tested-by: from you if you don't mind?

Fine with me :)

=2D-=20
Dan Smith
IBM Linux Technology Center
Open Hypervisor Team
email: danms@us.ibm.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIT/PuwtEf7b4GJVQRAhTvAJ9ZnLeLdj7kM1KNZfDZbHfgzU5UugCZAd9R
O8X6AL3irl7bkwpCmwCn364=
=OCIs
-----END PGP SIGNATURE-----
--=-=-=--
