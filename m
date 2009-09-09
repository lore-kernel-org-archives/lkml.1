Return-Path: <linux-kernel-owner+w=401wt.eu-S1753112AbZIIRoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbZIIRoo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 13:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbZIIRon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 13:44:43 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:36636 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbZIIRon (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 13:44:43 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josht@linux.vnet.ibm.com,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org
Subject: Re: [PATCH tip/core/rcu 0/3] increase rcutorture intensity and fix a couple resulting bugs
In-Reply-To: Your message of "Tue, 08 Sep 2009 15:53:49 PDT."
             <20090908225349.GA19524@linux.vnet.ibm.com>
From: Valdis.Kletnieks@vt.edu
References: <20090908225349.GA19524@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1252518239_3993P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 09 Sep 2009 13:43:59 -0400
Message-ID: <21629.1252518239@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1252518239_3993P
Content-Type: text/plain; charset=us-ascii

On Tue, 08 Sep 2009 15:53:49 PDT, "Paul E. McKenney" said:
> This patch series increases the intensity of rcutorture testing for
> TREE_PREEMPT_RCU and provides fixes for a couple resulting bugs.

Minor bisection nit - should patch 1/3 be renumbered to 3/3, so the two bugfix
patches go in before the patch that makes the unpatched bugs visible? Otherwise
if a bisect waypoint happens to land on 1/3, oddness can happen...

--==_Exmh_1252518239_3993P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKp+lfcC3lWbTT17ARAinAAKDN+oXINgzwGmuadA4MPq1xHcvQUwCfTDyC
AMGzmjhfajGubRxtP37mZ9o=
=oJgN
-----END PGP SIGNATURE-----

--==_Exmh_1252518239_3993P--
