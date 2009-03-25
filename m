Return-Path: <linux-kernel-owner+w=401wt.eu-S1756278AbZCYV2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278AbZCYV2w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 17:28:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752879AbZCYV2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 17:28:41 -0400
Received: from mail.gmx.net ([213.165.64.20]:32827 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755283AbZCYV2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 17:28:40 -0400
X-Authenticated: #24941321
X-Provags-ID: V01U2FsdGVkX1+5UWUf/ue5PY1eAOS3cZMCLq2gOgWXpEG6KrbwQb
	r2pk7qGl23vzae
Date: Wed, 25 Mar 2009 22:28:29 +0100 (CET)
From: Detlef Tschirschky <detlef.tschirschky@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: pppoe over ethernet
Message-ID: <alpine.LNX.2.00.0903252206520.7962@speedy.coe.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
X-gpg-Key: 30BACD55
X-gpg-fingerprint: EC55 B795 94FC 5D0C DD51  FFC1 A6F9 CA5E 30BA CD55
Org: Centre of Excellence
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512



Hi Peoples,

after update kernel 2.6.29 i got disconnects to my ISP.
This happens 5 - 7 times in 12 hours.
Reconnect fails only reboot solve that.
Never before i have this kind of problems so i did a
downgrade to 2.6.28.8 and all works fine again.

Internet:	t-online in germany, dsl 6000.
Connectiontype:	pppoe over ethernet
Netcard:	3c905B 100BaseTX [Cy3c905B 100BaseTX [Cyclone] (rev 30)

Hope that helps

regards
Pauli

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEAREKAAYFAknKof4ACgkQTdcxRo7lKJ2w9gCfWGw67eyF355qXrWVOdTTMuXu
EEsAn3UetAaNwC1H55sSU7CelWxCfWXq
=BCOK
-----END PGP SIGNATURE-----
