Return-Path: <linux-kernel-owner+w=401wt.eu-S1761497AbXIRVql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761497AbXIRVql (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 17:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756783AbXIRVqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 17:46:30 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:37019 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034AbXIRVq3 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 17:46:29 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Combine instrumentation menus in kernel/Kconfig.instrumentation
In-Reply-To: Your message of "Tue, 18 Sep 2007 17:12:59 EDT."
             <20070918211259.GA14927@Krystal>
From: Valdis.Kletnieks@vt.edu
References: <20070918211259.GA14927@Krystal>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1190151939_4811P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 18 Sep 2007 17:45:39 -0400
Message-ID: <14754.1190151939@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1190151939_4811P
Content-Type: text/plain; charset=us-ascii

On Tue, 18 Sep 2007 17:12:59 EDT, Mathieu Desnoyers said:

> +++ linux-2.6-lttng/kernel/Kconfig.instrumentation	2007-09-18 13:18:17.000
000000 -0400
> @@ -0,0 +1,40 @@
> +menuconfig INSTRUMENTATION
> +	bool "Instrumentation Support"
> +	default y
> +	---help---
> +	  Say Y here to get to see options related to performance measurement,
> +	  debugging, and testing. This option alone does not add any kernel code.
> +
> +	  If you say N, all options in this submenu will be skipped and disabled.

OK, I'll bite - given the mention of 'debugging' there, do we want to go for
broke and *also* suck in the 'Kernel Hacking' menu as well?

--==_Exmh_1190151939_4811P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG8EcDcC3lWbTT17ARAqgHAKC/IvJGyJK8DlAOlA+HZg5zKhueEwCgrdbn
4GH5l6zC6OGaa83eaDxjyeo=
=egQB
-----END PGP SIGNATURE-----

--==_Exmh_1190151939_4811P--
