Return-Path: <linux-kernel-owner+w=401wt.eu-S1757231AbZD2P6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231AbZD2P6X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 11:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756518AbZD2P57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 11:57:59 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:33565 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741AbZD2P56 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 11:57:58 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: reinette chatre <reinette.chatre@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Zhu, Yi" <yi.zhu@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: mmotm 2009-04-27-15-45 uploaded - iwl3945 oops
In-Reply-To: Your message of "Tue, 28 Apr 2009 13:39:44 PDT."
             <1240951184.1207.11.camel@rc-desk>
From: Valdis.Kletnieks@vt.edu
References: <200904272305.n3RN51mu031395@imap1.linux-foundation.org> <25818.1240938876@turing-police.cc.vt.edu>
            <1240951184.1207.11.camel@rc-desk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1241020608_4397P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 29 Apr 2009 11:56:48 -0400
Message-ID: <24133.1241020608@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1241020608_4397P
Content-Type: text/plain; charset=us-ascii

On Tue, 28 Apr 2009 13:39:44 PDT, reinette chatre said:

> Could you please revert this and test again?
> 
> If this does not help, could you please bisect?

Same kernel that oopsed 2 nights ago failed to do so in 8 or 9 hours last
night - so it isn't a "fire up wpa_supplicant and know inside 20 or 30 seconds
if the kernel tested is good" candidate for bisection.  Will collect what
info I can.

--==_Exmh_1241020608_4397P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJ+HjAcC3lWbTT17ARAoY2AJ9Mo5LJskC3QkgOuboLi91suvei8wCg8pDO
9qMg0BEieIa5hB5sfpKcFFg=
=v625
-----END PGP SIGNATURE-----

--==_Exmh_1241020608_4397P--
