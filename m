Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab0BJPHX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 10:07:23 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:57938 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753010Ab0BJPHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 10:07:22 -0500
X-Sasl-enc: nGKx1DQf1nGkQjV5ZMDjQcZZyAkWf00qZuB4DGkmWN5Z 1265814441
Message-ID: <4B72CBA6.2040605@imap.cc>
Date: Wed, 10 Feb 2010 16:07:18 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; de; rv:1.9.1.7) Gecko/20100104 SeaMonkey/2.0.2
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@web.de>
CC: David Miller <davem@davemloft.net>, Karsten Keil <isdn@linux-pingi.de>,
       linux-kernel@vger.kernel.org, i4ldeveloper@listserv.isdn4linux.de,
       isdn4linux@listserv.isdn4linux.de, netdev@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH v2 00/41] CAPI: Major rework, tons of bug fixes
References: <cover.1265659933.git.jan.kiszka@web.de>
In-Reply-To: <cover.1265659933.git.jan.kiszka@web.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Am 2010-02-08 21:12 schrieb Jan Kiszka:
> Here is the second take of my CAPI rework. I tried to address all
> feedback on v1 [...] 
> I kept my capifs fixes though this thing should die in the future. The
> work is done, and people may still use it due to their distro
> configuration (and the hard-wired loading by capiinit - needs fixing).

Great work. Many thanks for going through that effort!

T.

- -- 
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Ungeöffnet mindestens haltbar bis: (siehe Rückseite)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAktyy6YACgkQQ3+did9BuFvj7QCeO+qncLR2yGECEadwnWcVDo8Q
piEAnj6ZzuZ4z68SmzI20YVV6AQN9LE9
=m+sN
-----END PGP SIGNATURE-----
