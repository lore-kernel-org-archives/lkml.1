Return-Path: <linux-kernel-owner+w=401wt.eu-S1754735AbYDBLIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735AbYDBLIv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 07:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753473AbYDBLIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 07:08:44 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:35430 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427AbYDBLIo (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 07:08:44 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Miles Lane <miles.lane@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       ipw3945-devel@lists.sourceforge.net, Zhu Yi <yi.zhu@intel.com>,
       reinette.chatre@intel.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25-rc8-mm1
In-Reply-To: Your message of "Wed, 02 Apr 2008 03:49:14 PDT."
             <a44ae5cd0804020349v695e22b6k3c273a5724c5d52e@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <20080401213214.8fbb6d6b.akpm@linux-foundation.org>
            <a44ae5cd0804020349v695e22b6k3c273a5724c5d52e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1207134511_27002P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 02 Apr 2008 07:08:31 -0400
Message-ID: <1405.1207134511@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1207134511_27002P
Content-Type: text/plain; charset=us-ascii

On Wed, 02 Apr 2008 03:49:14 PDT, Miles Lane said:
>   CC [M]  drivers/net/wireless/iwlwifi/iwl3945-base.o
> drivers/net/wireless/iwlwifi/iwl3945-base.c: In function
> 'iwl3945_build_tx_cmd_basic':
> drivers/net/wireless/iwlwifi/iwl3945-base.c:2492: error: 'struct
> iwl3945_priv' has no member named 'rxtxpackets'
> make[4]: *** [drivers/net/wireless/iwlwifi/iwl3945-base.o] Error 1

Caused by this:

> CONFIG_IWL3945_LEDS=y

Apparently not ready for prime time...




--==_Exmh_1207134511_27002P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFH82kvcC3lWbTT17ARAvzgAKC67Avu8HL6FizqM9xCvthlntC1rwCgsnT7
GV2OxmZJ4gFpwvZnRdo9q2M=
=VjAf
-----END PGP SIGNATURE-----

--==_Exmh_1207134511_27002P--
