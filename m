Return-Path: <linux-kernel-owner+w=401wt.eu-S1761865AbXERKRO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761865AbXERKRO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 06:17:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755216AbXERKRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 06:17:00 -0400
Received: from 13.2-host.augustakom.net ([80.81.2.13]:50059 "EHLO phoebee.mail"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754955AbXERKQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 06:16:59 -0400
X-Greylist: delayed 1406 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 May 2007 06:16:58 EDT
Date: Fri, 18 May 2007 11:53:30 +0200
From: Martin Zwickel <martin.zwickel@technotrend.de>
To: Martin Mokrejs <mmokrejs@ribosome.natur.cuni.cz>
Cc: linux-kernel@vger.kernel.org, ext3-users@redhat.com
Subject: Re: 2.6.22-rc1 killed my ext3 filesystem cleanly unmounted
Message-ID: <20070518115330.0971682d@phoebee>
In-Reply-To: <20070518090604.GA10841@ribosome.natur.cuni.cz>
References: <20070518090604.GA10841@ribosome.natur.cuni.cz>
X-Mailer: Claws Mail 2.9.0cvs6 (GTK+ 2.10.12; i686-pc-linux-gnu)
X-Operating-System: Linux Phoebee 2.6.7-rc2-mm2 i686 Intel(R) Pentium(R) 4
 CPU 2.40GHz
X-Face: $rTNP}#i,cVI9h"0NVvD.}[fsnGqI%3=N'~,}hzs<FnWK/T]rvIb6hyiSGL[L8S,Fj`u1t.
 ?J0GVZ4&
Organization: Technotrend AG
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEUhITTZ2e7QzMp4ZjiXl6TO
 rmtPQq75iX51AAAAB3RJTUUHsQwfFzs7RBhzUQAAAgpJREFUOI1t1M+SojAQBvDUyHIP+gI0yV1J
 mLPTNJ63yGTO1hTL+z/CfknURWdTpYf+5WvzB1ReynBPQ0b1octoiEQu6ypMQq0+PICMrHksAvsH
 mH9ZH0LtHRoSe69fZJppfwP0DaUuY71IpK5AY9i+l/n2uK48zTdAIH5loFAjZT8LpMD8ifKFLTpe
 FxPLPlLARqxqsPG3Uqoim6EhtmRjqNUfG98T8JSBDMU5xnBV3zEeATueAoAQcANAqW+bQSU4NWQ4
 qN08o/sbbYDYYO1LnJF4u7fC1N6wdDU2FrcwOdULMza7xLTQJbgCI2CUCZtdQpq7uAwVY+eAdApV
 LlUlUYnvFDs5rtcaJYdKDAm8cKeiMwBV4Ff5cSHcB2BN6dyqQMXUZri+gKN058MTpLV5T7pAXogb
 3LVmfEvXtzc4JwiD82ITOM7gMtQcosM1xTiE1AngBx7TIcSAKgIxBwD9yIJWKOBGjnhscyBB5/Ov
 O9wVrsXtciABudQL3VzedQkATniaJa0LIRyvp/YGH3hsWfKFYjpTCeSnHQ8DiUsJedQz4JVJL43I
 pv54P6iMVr9CIa3/Ay9jA9RuOt1hNB5n4fr9Sev0ecDZVKYi2nU96XP/DIdK66rrxXQ/4cD7nR/P
 1Q8Q6nxlxi3sHR/8wbmuH9v9plWD42ixVtJto3X7Aq8b9Lf/JHke4184VLhUB3OxCQAAAABJRU5E
 rkJggg==
Mime-Version: 1.0
Content-Type: multipart/signed; boundary=Sig_GM2S_VGlnUMJgkwb6Ee__IP;
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_GM2S_VGlnUMJgkwb6Ee__IP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 18 May 2007 11:06:04 +0200
Martin Mokrejs <mmokrejs@ribosome.natur.cuni.cz> bubbled:

>   I cannot say what is the fsck version, but I can tell you this is a=20
> Gentoo linux box in the ~x86 tree, so whatever is in the "unstable"=20
> branch. :(

FYI:
# eix e2fs
[I] sys-fs/e2fsprogs
     Available versions:  1.39 ~1.39-r1 1.39-r2 ~1.40_pre20070411

So probably 1.40_pre20070411.


Regards,
Martin

--=20
MyExcuse:
/pub/lunch

Martin Zwickel <martin.zwickel@technotrend.de>
Research & Development

--Sig_GM2S_VGlnUMJgkwb6Ee__IP
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGTXeamjLYGS7fcG0RAgBtAJ9qnK9tTJyLdrH0XpuagWKpXwi2EQCgloxq
ztCeqtNVE77ATxD+tQpMLmE=
=g6Bt
-----END PGP SIGNATURE-----

--Sig_GM2S_VGlnUMJgkwb6Ee__IP--
