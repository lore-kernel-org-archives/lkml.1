Return-Path: <linux-kernel-owner+w=401wt.eu-S933827AbXCUTwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933827AbXCUTwy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 15:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933821AbXCUTwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 15:52:54 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:55455 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933827AbXCUTwx (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 15:52:53 -0400
Message-Id: <200703211951.l2LJpVPS020364@turing-police.cc.vt.edu>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Adam Litke <agl@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Christoph Hellwig <hch@infradead.org>, Ken Chen <kenchen@google.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: pagetable_ops: Hugetlb character device example
In-Reply-To: Your message of "Wed, 21 Mar 2007 14:43:48 CDT."
             <1174506228.21684.41.camel@localhost.localdomain>
From: Valdis.Kletnieks@vt.edu
References: <20070319200502.17168.17175.stgit@localhost.localdomain>
            <1174506228.21684.41.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1174506691_3868P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 21 Mar 2007 15:51:31 -0400
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1174506691_3868P
Content-Type: text/plain; charset=us-ascii

On Wed, 21 Mar 2007 14:43:48 CDT, Adam Litke said:
> The main reason I am advocating a set of pagetable_operations is to
> enable the development of a new hugetlb interface.

Do you have an exit strategy for the *old* interface?

--==_Exmh_1174506691_3868P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGAYzDcC3lWbTT17ARAgxrAJ9p9iZEHQ6XEFuQIilvoH+JvMSxMwCg2iKF
h8VzoNH+PYZGXgZJhTXYBko=
=Fp4f
-----END PGP SIGNATURE-----

--==_Exmh_1174506691_3868P--
