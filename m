Return-Path: <linux-kernel-owner+w=401wt.eu-S1759554AbYHOSHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759554AbYHOSHf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 14:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755079AbYHOSH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 14:07:26 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:58114 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571AbYHOSH0 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 14:07:26 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: david@lang.hm
Cc: "Press, Jonathan" <Jonathan.Press@ca.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Helge Hafting <helge.hafting@aitel.hist.no>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       hch@infradead.org, andi@firstfloor.org, viro@ZenIV.linux.org.uk,
       alan@lxorguk.ukuu.org.uk, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [malware-list] TALPA - a threat model? well sorta.
In-Reply-To: Your message of "Fri, 15 Aug 2008 10:47:15 PDT."
             <alpine.DEB.1.10.0808151042500.15109@asgard.lang.hm>
From: Valdis.Kletnieks@vt.edu
References: <1218645375.3540.71.camel@localhost.localdomain> <20080813103951.1e3e5827@infradead.org> <1218653864.3540.109.camel@localhost.localdomain> <20080813143908.38796217@infradead.org> <1218723133.3540.137.camel@localhost.localdomain> <48A55574.9070508@aitel.hist.no> <1218796645.10800.242.camel@twins> <2629CC4E1D22A64593B02C43E855530304AE4BF6@USILMS12.ca.com> <alpine.DEB.1.10.0808150924260.15109@asgard.lang.hm> <2629CC4E1D22A64593B02C43E855530304AE4C0C@USILMS12.ca.com> <alpine.DEB.1.10.0808151032121.15109@asgard.lang.hm> <2629CC4E1D22A64593B02C43E855530304AE4C12@USILMS12.ca.com>
            <alpine.DEB.1.10.0808151042500.15109@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1218823607_3568P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 15 Aug 2008 14:06:47 -0400
Message-ID: <22811.1218823607@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1218823607_3568P
Content-Type: text/plain; charset=us-ascii

On Fri, 15 Aug 2008 10:47:15 PDT, david@lang.hm said:

> in any case the vunerability is limited as the next time the signatures 
> are updated the files would get scanned again, so I don't think it's a big 
> problem in practice.

This problem is actually identical to "new file scanned, but you don't have
the signature available yet so malware isn't detected".

Those of us who have seen large mail servers pile up queues in the 10s of
millions in the 45 minutes between when the worm went critical-mass and when
we got a signature might disagree on it not being a big problem in practice.

Of course, if that's considered "outside" the threat model, somebody better
start writing down exactly what small corner of threat model this is actually
helping against...


--==_Exmh_1218823607_3568P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIpcW3cC3lWbTT17ARAnjyAJ9tM3fBh2x53Fbt9QCCd3usUqyfeQCdFcTY
aiFFSXounw769JwRTCsh4M4=
=f2zq
-----END PGP SIGNATURE-----

--==_Exmh_1218823607_3568P--
