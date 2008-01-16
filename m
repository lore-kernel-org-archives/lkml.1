Return-Path: <linux-kernel-owner+w=401wt.eu-S1753307AbYAPMYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbYAPMYn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 07:24:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbYAPMYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 07:24:35 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:33850 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbYAPMYf (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 07:24:35 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: balbir@linux.vnet.ibm.com
Cc: Andrea Righi <righiandr@users.sourceforge.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] per-uid/gid I/O throttling (was Re: [RFC][PATCH] per-task I/O throttling)
In-Reply-To: Your message of "Wed, 16 Jan 2008 17:35:33 +0530."
             <20080116120533.GB7166@balbir.in.ibm.com>
From: Valdis.Kletnieks@vt.edu
References: <47879A32.8060508@users.sourceforge.net> <3777.1200113861@turing-police.cc.vt.edu> <1200131197.7999.14.camel@lappy> <20080112105702.GC25388@balbir.in.ibm.com> <1200136245.7999.20.camel@lappy> <4789006C.2030804@users.sourceforge.net> <20080113044607.GA13633@balbir.in.ibm.com> <478CE41F.5010401@users.sourceforge.net> <20080116104541.GB25724@balbir.in.ibm.com> <13594.1200483031@turing-police.cc.vt.edu>
            <20080116120533.GB7166@balbir.in.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1200486246_2966P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 16 Jan 2008 07:24:06 -0500
Message-ID: <16301.1200486246@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1200486246_2966P
Content-Type: text/plain; charset=us-ascii

On Wed, 16 Jan 2008 17:35:33 +0530, Balbir Singh said:

> Control groups is derived from cpusets and for those interested in
> grouping tasks for control, is the preferred method of providing
> control.

Ahh, that's why I didn't notice it - "cpusets" didn't seem to do much for the 1
and 2 CPU systems I usually deal with so I filtered it out (including the parts
where it started becoming relevant to things I do).  Often, the right tool for
a job is something you've never heard of because it originated in some other
specialized area...


--==_Exmh_1200486246_2966P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHjfdmcC3lWbTT17ARAsCYAKDPRguvHBAHNUDa6vDSoEB0Y1rERACfRDEV
XE/GY5z1bQevTkD9hNbBoOM=
=9lEs
-----END PGP SIGNATURE-----

--==_Exmh_1200486246_2966P--
