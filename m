Return-Path: <linux-kernel-owner+w=401wt.eu-S1754406AbZGVV6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406AbZGVV6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 17:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754294AbZGVV6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 17:58:18 -0400
Received: from imp02.mtu.ru ([62.5.255.19]:55860 "EHLO imp02.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754183AbZGVV6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 17:58:18 -0400
From: Pavel Vasilyev <pavel@pavlinux.ru>
Reply-To: pavel@pavlinux.ru
Organization: Pavlinux Inc.
To: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: GART_IOMMU without AGP
Date: Thu, 23 Jul 2009 01:58:06 +0400
User-Agent: KMail/1.9.10
References: <200907221926.50397.pavel@pavlinux.ru> <20090722213746.GA20241@redhat.com>
In-Reply-To: <20090722213746.GA20241@redhat.com>
X-Face: =?utf-8?q?=2EqZWJ=3F=248Zrl=26r=7C-=3B8=7ESTufc!R0d=5E=3FdE-g/S=5FryU2S=5D=27?=
 =?utf-8?q?=24vQ7EYY=3DBSj=5DJ-Gp=5FVXPpl=27ci/i=0A=09yH=5B=249HGUU=3Af?=@6hyHiQKeEv#S(K4XtVe$?0UO@',
 =?utf-8?q?!=25=5CR=3A7a=3BITA=3B=7Cs=7C=3F=25+T6=7E5=3Aq=2E2i=5DzA=25=0A=09?=
 =?utf-8?q?Mn-t3kOWGQ?=(7@ZOZ/0@+baHY#Fj&e/k'#p}#F<U{[DP[@"XbG&pmU~{oOMsPc4q|4/,
 =?utf-8?q?du8=0A=09?="'s*i`2=h[f!7!`#',39O3
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3025347.dAUiAPe5lO";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200907230158.15417.pavel@pavlinux.ru>
X-Spam-Flag: NO
X-Spam-Yversion: Spamooborona-3.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3025347.dAUiAPe5lO
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday 23 July 2009 01:37:46 Dave Jones wrote:
> The lack of AGP slots doesn't mean a lack of AGP bus.
> It's part of the K8 on-CPU northbridge.

Fine. But if I do not have AGP-card, why do I need the support of bus AGP? :)
It may allow the user to the toggle on or off when needed.

--nextPart3025347.dAUiAPe5lO
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBKZ4t3OqfDywN0JIkRAgApAJ9ZTAZpcqEyqJdWtuvraDg2x/zsvACeNtAB
+GOKdj4kTrQ6etYU/DqwgMk=
=HdXe
-----END PGP SIGNATURE-----

--nextPart3025347.dAUiAPe5lO--
