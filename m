Return-Path: <linux-kernel-owner+w=401wt.eu-S1760874AbXGLJfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760874AbXGLJfx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 05:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbXGLJfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 05:35:45 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:42205 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbXGLJfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 05:35:44 -0400
Subject: Re: [PATCH 2/2] workqueue: debug work related deadlocks with
	lockdep
From: Johannes Berg <johannes@sipsolutions.net>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20070706125324.GA74@tv-sign.ru>
References: <20070705110744.564273000@sipsolutions.net>
	 <20070705110820.622888000@sipsolutions.net>
	 <20070705153648.GA236@tv-sign.ru> <1183718633.3818.96.camel@johannes.berg>
	 <20070706125324.GA74@tv-sign.ru>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+v+NVPnTN/yGThsWoPMh"
Date: Wed, 11 Jul 2007 13:37:06 +0200
Message-Id: <1184153827.3738.51.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-+v+NVPnTN/yGThsWoPMh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-07-06 at 16:53 +0400, Oleg Nesterov wrote:

> Yes, got it, but forgot to reply to myself. But thanks for your confirmat=
ion
> of my understanding.

:)

> I believe both patches are nice.

Is there anything I should be doing now to get these patches in?

johannes

--=-+v+NVPnTN/yGThsWoPMh
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGlMDi/ETPhpq3jKURAtEuAJ4qGfIbItSJDii8zeQCyZq8lm4TUgCcDuB9
K05C4c10WlCAiRSt9V5/dNQ=
=GkXk
-----END PGP SIGNATURE-----

--=-+v+NVPnTN/yGThsWoPMh--

