Return-Path: <linux-kernel-owner+w=401wt.eu-S1754530AbZHMNk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbZHMNk3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 09:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754409AbZHMNk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 09:40:28 -0400
Received: from mail-yw0-f193.google.com ([209.85.211.193]:53300 "EHLO
	mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313AbZHMNk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 09:40:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=anX9T5xwTn6T/WtA6ky2VnVtsl17LU2Me73z+4OmJX6n7Ja5W9rMkYSUdZA4XCO/Na
         h04F72BwnBK2wFhumbOWWeiItwcY/GYGs1chj+4aPds6GLseM/+FC4jWuPrNDrUgM1VV
         0UngOfcM32zAcAYmO64Y+gRNMTbjmU81vFjN4=
Date: Thu, 13 Aug 2009 16:43:39 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Len Brown <lenb@kernel.org>
Cc: Len Brown <len.brown@intel.com>, Lin Ming <ming.m.lin@intel.com>,
       Bob Moore <robert.moore@intel.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: acpi_ex_system_memory_space_handler oops
Message-ID: <20090813134339.GA5660@localdomain.by>
References: <20090812201034.GA2983@localdomain.by>
 <alpine.LFD.2.00.0908122009170.22946@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0908122009170.22946@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

rc5-git0
FAIL

rc4-got0
seems to be ok (after 15 reboots).

	Sergey
--liOOAslEiF7prFVr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAkqEGIsACgkQfKHnntdSXjS25AP/VMnEM/orQlpa6aYQVK+sa+Dz
0/CMzLhtrpKjBF0C6d1uQ1TCAR8BdsvSS4xCSJB8uxgE2m+C0DfG1/6Z/9nhW12t
6NvJTlod77+nB7vjjSrDnmODgN7ceTyJMF1u2Y/6rZCWg2kTKnbJVXOlITShDY2y
bW4SCu6Ry2G2X9VQHdw=
=trgh
-----END PGP SIGNATURE-----

--liOOAslEiF7prFVr--
