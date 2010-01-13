Return-Path: <linux-kernel-owner+w=401wt.eu-S1755728Ab0AMLjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728Ab0AMLjf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 06:39:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518Ab0AMLjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 06:39:35 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:37053 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755537Ab0AMLje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 06:39:34 -0500
X-Sasl-enc: uqhU8/wyQ6cqC0MI1ip7TZ69YqmBQ08M3WR2TPgGY7iv 1263382757
Message-ID: <4B4DB0E3.9020707@imap.cc>
Date: Wed, 13 Jan 2010 12:39:15 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; de; rv:1.9.1.7) Gecko/20100104 SeaMonkey/2.0.2
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: =?ISO-8859-1?Q?Ren=E9_Bolldorf?= <xsecute@googlemail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [Question]  For what stand's __initdata, __devinit etc. ?
References: <4B4CAA49.4090707@googlemail.com> <20100112234228.GA21777@khazad-dum.debian.net>
In-Reply-To: <20100112234228.GA21777@khazad-dum.debian.net>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Am 2010-01-13 00:42 schrieb Henrique de Moraes Holschuh:
> On Tue, 12 Jan 2010, René Bolldorf wrote:
>> Hi,
>> Do we really need this?
>> It will be nice if someone can me explain this.
> 
> http://kernelnewbies.org/FAQ/InitExitMacros

That's far from complete. It does not, for example, mention __devinit.

- -- 
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Ungeöffnet mindestens haltbar bis: (siehe Rückseite)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAktNsOMACgkQQ3+did9BuFtfrwCfUO+z1SWLRs97+lrfp6FjC61a
dzwAnR02pQ+qAdSN58YEh1kL8BwoRwqz
=z9Hb
-----END PGP SIGNATURE-----
