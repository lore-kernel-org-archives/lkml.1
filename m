Return-Path: <linux-kernel-owner+w=401wt.eu-S1753427AbYIZNWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427AbYIZNWt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 09:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbYIZNWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 09:22:41 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:36313 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbYIZNWk (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 09:22:40 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Zachary Amsden <zach@vmware.com>,
       Alok Kataria <akataria@vmware.com>,
       Alok kataria <alokkataria1@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Yan Li <elliot.li.tech@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
       "rjmaomao@gmail.com" <rjmaomao@gmail.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Daniel Hecht <dhecht@vmware.com>
Subject: Re: [PATCH 1/2] VMware detection support for x86 and x86-64
In-Reply-To: Your message of "Fri, 26 Sep 2008 14:47:21 +0200."
             <48DCD9D9.9080008@redhat.com>
From: Valdis.Kletnieks@vt.edu
References: <20080221115452.GB13948@elte.hu> <20080907234510.GA24133@yantp.cn.ibm.com> <20080908140423.GG11993@elte.hu> <35f686220809241928k3669e30bi8a98b440443c4bff@mail.gmail.com> <48DB15DB.8040501@zytor.com> <1222317978.23524.117.camel@alok-dev1> <48DB1984.8020704@zytor.com> <1222318928.23524.121.camel@alok-dev1> <48DB1BCE.2070106@zytor.com> <1222320201.23524.135.camel@alok-dev1> <1222375694.27056.179.camel@bodhitayantram.eng.vmware.com> <48DC09D9.7040204@zytor.com> <1222381254.27056.194.camel@bodhitayantram.eng.vmware.com> <48DC105D.9050803@zytor.com>
            <48DCD9D9.9080008@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1222435332_7097P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 26 Sep 2008 09:22:12 -0400
Message-ID: <40178.1222435332@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1222435332_7097P
Content-Type: text/plain; charset=us-ascii

On Fri, 26 Sep 2008 14:47:21 +0200, Gerd Hoffmann said:
>   Hi,
> 
> > This, of course, is what CPUID is for.
> 
> ... except that it doesn't always work.  It requires vmx/svm, otherwise
> cpuid doesn't trap and thus can't be filled by the hypervisor ...

Which would be hardware implementers in the '80s getting wrong the first few
times what IBM did right the first time.  Doesn't *anybody* do literature
searches before doing stuff anymore? ;)

--==_Exmh_1222435332_7097P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFI3OIEcC3lWbTT17ARAi5VAJ9dijtbdh9op8BLH7Qc19o8h2YpTQCfdUXR
pX2rnt43OxUuG8BeY/LDN+I=
=U7ln
-----END PGP SIGNATURE-----

--==_Exmh_1222435332_7097P--
