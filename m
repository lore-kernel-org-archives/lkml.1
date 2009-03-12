Return-Path: <linux-kernel-owner+w=401wt.eu-S1755381AbZCLMM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381AbZCLMM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 08:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753293AbZCLMMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 08:12:18 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:58173 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597AbZCLMMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 08:12:17 -0400
Date: Thu, 12 Mar 2009 13:12:07 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Neil Horman <nhorman@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Wu Fengguang <fengguang.wu@intel.com>, Pekka Paalanen <pq@iki.fi>
Subject: Re: [PATCH 0/4] [GIT PULL] memory saving ring buffer for
 tip/tracing/ftrace
Message-ID: <20090312131207.1c7fa213@mjolnir.ossman.eu>
In-Reply-To: <20090312104721.GA6005@shamino.rdu.redhat.com>
References: <20090312023720.144716747@goodmis.org>
	<20090312080758.4a14d5b4@mjolnir.ossman.eu>
	<20090312104721.GA6005@shamino.rdu.redhat.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.drzeus.cx-8585-1236859932-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-8585-1236859932-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 12 Mar 2009 06:47:21 -0400
Neil Horman <nhorman@redhat.com> wrote:

> On Thu, Mar 12, 2009 at 08:07:58AM +0100, Pierre Ossman wrote:
> >=20
> > How difficult is it to apply this to 2.6.27? Fedora is still on that
> > kernel and it would be nice if I could get my memory back on a
> > distribution kernel. :)
>=20
> I'm looking into it currently.  I'll post a test kernel when I have somet=
hing
> for you.

F9 kernel if possible, as that's what the test machine is running.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-8585-1236859932-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkm4/BkACgkQ7b8eESbyJLiDGACgt3LabKrdrGIjKFMPsQGHoMAH
e6QAn2WzFy3iZBS4wDa9+fLys6+ZZOEq
=Nfgr
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-8585-1236859932-0001-2--
