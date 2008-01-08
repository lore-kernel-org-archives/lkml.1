Return-Path: <linux-kernel-owner+w=401wt.eu-S1757695AbYAHLCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757695AbYAHLCo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 06:02:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbYAHLCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 06:02:35 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:64221 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751445AbYAHLCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 06:02:34 -0500
Subject: Re: [PATCH 12/11] sched: rt-group: uid-group interface
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: vatsa@linux.vnet.ibm.com, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       dmitry.adamushko@gmail.com, Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20080108105733.GA2569@linux.vnet.ibm.com>
References: <20080106161128.152634000@chello.nl>
	 <1199703080.7143.24.camel@twins>
	 <20080107122330.GB25945@linux.vnet.ibm.com>
	 <1199725063.31975.53.camel@lappy>
	 <20080108105733.GA2569@linux.vnet.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-UN+MSI/9pl+wgukrbVCI"
Date: Tue, 08 Jan 2008 12:02:30 +0100
Message-Id: <1199790150.7143.57.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-UN+MSI/9pl+wgukrbVCI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Tue, 2008-01-08 at 16:27 +0530, Dhaval Giani wrote:
> On Mon, Jan 07, 2008 at 05:57:42PM +0100, Peter Zijlstra wrote:
> >=20
> > Subject: sched: rt-group: add uid-group interface
> >=20
> > Extend the /sys/kernel/uids/<uid>/ interface to allow setting
> > the group's rt_period and rt_runtime.
> >=20
>=20
> Hi Peter,
>=20
> Cool stuff! I will try out these patches and try to give you some
> feedback.

Thanks, much appreciated!

> One request though, could you please add some documentation to
> Documentation/ABI/testing/sysfs-kernel-uids?

I already have documentation on the todo list, I'll add this file to
that list :-)

--=-UN+MSI/9pl+wgukrbVCI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHg1hGXA2jU0ANEf4RAsmOAJ9dSYfAfdaz63BRdy/mj1FnOsrdtgCcCH1V
VmbT7ppupa08G6xlVIAYlls=
=lFFk
-----END PGP SIGNATURE-----

--=-UN+MSI/9pl+wgukrbVCI--

