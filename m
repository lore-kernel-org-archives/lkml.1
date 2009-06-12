Return-Path: <linux-kernel-owner+w=401wt.eu-S1759327AbZFLEWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759327AbZFLEWI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 00:22:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757232AbZFLEVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 00:21:45 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37033 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042AbZFLEVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 00:21:43 -0400
Date: Fri, 12 Jun 2009 13:50:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dave Jones <davej@redhat.com>
Subject: linux-next: manual merge of the rr tree with the cpufreq-current
 tree
Message-Id: <20090612135019.e1b3bde6.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__12_Jun_2009_13_50_19_+1000_kNb23OpFvp4J17Zv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__12_Jun_2009_13_50_19_+1000_kNb23OpFvp4J17Zv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

Today's linux-next merge of the rr tree got a conflict in
arch/x86/kernel/cpu/cpufreq/speedstep-ich.c between commit
ed5a409578578f263a362d6527ad9e5a493e2a44 ("[CPUFREQ] cpumask: avoid
playing with cpus_allowed in speedstep-ich.c") from the cpufreq-current
tree and commit a5b99ac32f444cd1b7d9aa60ee468de15f8d6964
("cpumask:remove-cpumask-games-arch-x86-kernel-cpu-cpufreq-speedstep-ich.c")
from the rr tree.

Just white space differences ... I used the version from the
cpufreq-current tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__12_Jun_2009_13_50_19_+1000_kNb23OpFvp4J17Zv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkox0HsACgkQjjKRsyhoI8xMugCgqLV9bByX3l2DKmpIMpfpKMop
xwIAnR+o0WjIPOuMRuBafd4zXwqPO938
=RCdd
-----END PGP SIGNATURE-----

--Signature=_Fri__12_Jun_2009_13_50_19_+1000_kNb23OpFvp4J17Zv--
