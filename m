Return-Path: <linux-kernel-owner+w=401wt.eu-S1752277AbZECVpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277AbZECVpp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 17:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751712AbZECVpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 17:45:36 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:38225 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbZECVpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 17:45:35 -0400
Message-ID: <49FE107A.4020406@poczta.fm>
Date: Sun, 03 May 2009 23:45:30 +0200
From: Lukasz Stelmach <stlman@poczta.fm>
User-Agent: Thunderbird 2.0.0.21 (X11/20090403)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Cc: yoshfuji@linux-ipv6.org
Subject: [PATCH] Temporary IPv6 address asignment
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------060305090705020803050207"
X-EMID: ae9b4138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060305090705020803050207
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Greetings.

I discovered recently and fixed some problems with IPv6 temporary
address asignment. I have described the problem at
http://bugzilla.kernel.org as bugs #13208 and #13221.

http://bugzilla.kernel.org/show_bug.cgi?id=13208
http://bugzilla.kernel.org/show_bug.cgi?id=13221

The patch is available at:

http://bugzilla.kernel.org/attachment.cgi?id=21201

- --
Było mi bardzo miło.               Czwarta pospolita klęska, [...]
>Łukasz<                 Już nie katolicka lecz złodziejska.  (c)PP
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkn+EHoACgkQNdzY8sm9K9yrgwCeJRSdh62YWfXQhF9hRiKR7XVC
s8YAnAvT7VkFuiUjoavpy/hu4+PYr53C
=FDQu
-----END PGP SIGNATURE-----


----------------------------------------------------------------------
Wygraj 3000 zl, wycieczke lub lot balonem!
Sprawdz >> http://link.interia.pl/f2154

--------------060305090705020803050207
Content-Type: text/x-vcard; charset=utf-8;
 name="stlman.vcf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="stlman.vcf"

YmVnaW46dmNhcmQNCmZuO3F1b3RlZC1wcmludGFibGU6PUM1PTgxdWthc3ogU3RlbG1hY2gN
Cm47cXVvdGVkLXByaW50YWJsZTpTdGVsbWFjaDs9QzU9ODF1a2Fzeg0KZW1haWw7aW50ZXJu
ZXQ6c3RsbWFuQHBvY3p0YS5mbQ0KeC1tb3ppbGxhLWh0bWw6RkFMU0UNCnZlcnNpb246Mi4x
DQplbmQ6dmNhcmQNCg0K
--------------060305090705020803050207--
