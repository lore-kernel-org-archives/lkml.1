Return-Path: <linux-kernel-owner+w=401wt.eu-S1754539AbZCLJUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbZCLJUf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 05:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750852AbZCLJU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 05:20:26 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:49235 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548AbZCLJUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 05:20:25 -0400
Date: Thu, 12 Mar 2009 10:20:14 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: kosaki.motohiro@jp.fujitsu.com, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Wu Fengguang <fengguang.wu@intel.com>, Pekka Paalanen <pq@iki.fi>,
       Neil Horman <nhorman@redhat.com>
Subject: Re: [PATCH 0/4] [GIT PULL] memory saving ring buffer for
 tip/tracing/ftrace
Message-ID: <20090312102014.7271f54e@mjolnir.ossman.eu>
In-Reply-To: <20090312163414.43B4.A69D9226@jp.fujitsu.com>
References: <20090312023720.144716747@goodmis.org>
	<20090312080758.4a14d5b4@mjolnir.ossman.eu>
	<20090312163414.43B4.A69D9226@jp.fujitsu.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.drzeus.cx-7229-1236849620-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-7229-1236849620-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 12 Mar 2009 16:34:55 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > How difficult is it to apply this to 2.6.27? Fedora is still on that
> > kernel and it would be nice if I could get my memory back on a
> > distribution kernel. :)
>=20
> Difficult.
> but you can use "trace_entries=3D1" kernel boot parameter :)
>=20

Ah. I got a tip for trace_buf_size=3D1, but that didn't work. Your
version was much better. :)

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-7229-1236849620-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkm409EACgkQ7b8eESbyJLj55wCgvrJ35u6C5JJZ47tFSHgZqWPU
4aUAoJ87decysYjJt15JbL+zwF9U5PQn
=6f3+
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-7229-1236849620-0001-2--
