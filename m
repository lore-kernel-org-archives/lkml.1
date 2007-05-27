Return-Path: <linux-kernel-owner+w=401wt.eu-S1756770AbXE0Bde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770AbXE0Bde (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 21:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbXE0Bd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 21:33:28 -0400
Received: from h80ad2262.async.vt.edu ([128.173.34.98]:54476 "EHLO
	h80ad2262.async.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbXE0Bd1 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 21:33:27 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: casey@schaufler-ca.com
Cc: Andreas Gruenbacher <agruen@suse.de>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM hook
In-Reply-To: Your message of "Sat, 26 May 2007 15:58:50 PDT."
             <990795.7773.qm@web36612.mail.mud.yahoo.com>
From: Valdis.Kletnieks@vt.edu
References: <990795.7773.qm@web36612.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1180229600_6097P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 26 May 2007 21:33:20 -0400
Message-ID: <9677.1180229600@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1180229600_6097P
Content-Type: text/plain; charset=us-ascii

On Sat, 26 May 2007 15:58:50 PDT, Casey Schaufler said:
> Fair enough, I don't believe that an argv[0] check ought to
> be used as a security mechanism. I am not convinced that everyone
> would agree with us.

Having seen my share of argv[0]-related security bugs in my years, I have to
agree that it's a security crock.  As to why some might not agree, you already
put your finger on it earlier:

On Fri, 25 May 2007 12:06:19 PDT, Casey Schaufler said:
> nefarious schemes. Remember that security is a subjective thing, and
> using argv[0] and AppArmor together might make some people feel better.

Some people would rather just feel better...


--==_Exmh_1180229600_6097P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGWN/gcC3lWbTT17ARAvirAKDOUC0J+x8By0TBq5PQaZ1S13IsMQCcCnU4
/ozyEmRdHJEC1LIycxA03Mg=
=u97t
-----END PGP SIGNATURE-----

--==_Exmh_1180229600_6097P--
