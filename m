Return-Path: <linux-kernel-owner+w=401wt.eu-S1755006AbZLYDuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006AbZLYDuz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 22:50:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665AbZLYDuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 22:50:54 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:60157 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbZLYDux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 22:50:53 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       Allan Stephens <allan.stephens@windriver.com>, netdev@vger.kernel.org,
       Per Liden <per.liden@ericsson.com>,
       tipc-discussion@lists.sourceforge.net, akpm@linux-foundation.org,
       Jon Maloy <jon.maloy@ericsson.com>
Subject: Re: [Patch] tipc: use kconfig to limit numeric ranges
In-Reply-To: Your message of "Thu, 24 Dec 2009 22:26:48 EST."
             <20091225032956.4556.69130.sendpatchset@localhost.localdomain>
From: Valdis.Kletnieks@vt.edu
References: <20091225032956.4556.69130.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1261713006_3923P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 24 Dec 2009 22:50:06 -0500
Message-ID: <31665.1261713006@localhost>
X-Mirapoint-Received-SPF: 128.173.34.103 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=steiner.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020207.4B34366F.00C4,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1261713006_3923P
Content-Type: text/plain; charset=us-ascii

On Thu, 24 Dec 2009 22:26:48 EST, Amerigo Wang said:
> We can rely on kconfig to limit these numbers,
> no need to limit them at compile time/run time.

> +          ***Only 1 (one cluster in a zone) is supported by current code.***
>  
>            (Max number of clusters inside TIPC zone. Max supported 
>            value is 4095 clusters, minimum is 1.

Given the limit of 1, maybe the reference to 4095 should be nuked?


--==_Exmh_1261713006_3923P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLNDZucC3lWbTT17ARAlxzAKDRM8KKzDY0zYl/wAFUChvTd/vmbQCfT+j3
mdckI3qPC5/4Wm2p1UrX1RE=
=DpWr
-----END PGP SIGNATURE-----

--==_Exmh_1261713006_3923P--

