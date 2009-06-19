Return-Path: <linux-kernel-owner+w=401wt.eu-S1754236AbZFSRzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbZFSRzd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 13:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbZFSRzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 13:55:25 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:51817 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbZFSRzZ (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 13:55:25 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Pavel Machek <pavel@ucw.cz>
Cc: James Morris <jmorris@namei.org>, Joseph Cihula <joseph.cihula@intel.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, hpa@zytor.com, andi@firstfloor.org,
       Chris Wright <chrisw@sous-sol.org>, jbeulich@novell.com,
       peterm@redhat.com, gang.wei@intel.com, shane.wang@intel.com
Subject: Re: [RFC v4][PATCH 2/2] intel_txt: Intel(R) TXT and tboot kernel support
In-Reply-To: Your message of "Fri, 19 Jun 2009 17:05:14 +0200."
             <20090619150514.GE1389@ucw.cz>
From: Valdis.Kletnieks@vt.edu
References: <4A299051.40405@intel.com> <alpine.LRH.2.00.0906121509001.14633@tundra.namei.org>
            <20090619150514.GE1389@ucw.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1245433922_4243P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 19 Jun 2009 13:52:02 -0400
Message-ID: <33858.1245433922@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1245433922_4243P
Content-Type: text/plain; charset=us-ascii

On Fri, 19 Jun 2009 17:05:14 +0200, Pavel Machek said:
> On Fri 2009-06-12 15:12:59, James Morris wrote:
> > On Fri, 5 Jun 2009, Joseph Cihula wrote:
> > 
> > > Linux support for Intel(R) Trusted Execution Technology.
> > 
> > > Signed-off-by:  Joseph Cihula <joseph.cihula@intel.com>
> > > Signed-off-by:  Shane Wang <shane.wang@intel.com>
> > > Signed-off-by:  Gang Wei <gang.wei@intel.com>
> > 
> > Reviewed-by: James Morris <jmorris@namei.org>
> > 
> > There have been no comments on this since you posted it, so we might 
> > assume there are no further technical issues.
> 
> I believe the code at best useless and at worst dangerous. We don't
> merge useless code to the kernel.
> 
> What are non-evil uses of this code?

Yes, most of the uses contemplated for this are for evil DRM schemes.  On the
other hand, the code is equally useful to help make sure that mo miscreant has
snuck evil DRM (or other evil code) in behind my back.

"Somebody has screwed with this kernel image, and you're not booting what you
thought you were booting."

Seems worth it to me.

--==_Exmh_1245433922_4243P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKO9BCcC3lWbTT17ARAuAgAJ40//fVU5Nx/Bu6h5El7s2TUJOdxwCeJUcg
XwqUqrR4sZZsunOXTIGXI7o=
=ErSc
-----END PGP SIGNATURE-----

--==_Exmh_1245433922_4243P--
