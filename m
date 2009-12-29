Return-Path: <linux-kernel-owner+w=401wt.eu-S1752175AbZL2Bid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbZL2Bid (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 20:38:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbZL2Bic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 20:38:32 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:38611 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbZL2Bic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 20:38:32 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 3/5] perf report: Add --hide-unresolved/-U command line option
In-Reply-To: Your message of "Mon, 28 Dec 2009 22:48:34 -0200."
             <1262047716-23171-3-git-send-email-acme@infradead.org>
From: Valdis.Kletnieks@vt.edu
References: <1262047716-23171-1-git-send-email-acme@infradead.org>
            <1262047716-23171-3-git-send-email-acme@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1262050532_3938P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 28 Dec 2009 20:35:32 -0500
Message-ID: <5686.1262050532@localhost>
X-Mirapoint-Received-SPF: 128.173.34.103 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=steiner.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020201.4B395CE5.0118,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1262050532_3938P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, 28 Dec 2009 22:48:34 -0200, Arnaldo Carvalho de Melo said:
> Useful to match the 'overhead' column in 'perf report' with the 'baseli=
ne' one
> in 'perf diff'.

Looks like a good one for tools/perf/Documentation/examples.txt ?


--==_Exmh_1262050532_3938P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLOVzkcC3lWbTT17ARAhQqAJ9yWFNtmFddxrgGTjZoUk1aBesmTgCgy+MQ
u6eH6ULXAcMeNHczLarvbE8=
=Bseu
-----END PGP SIGNATURE-----

--==_Exmh_1262050532_3938P--

