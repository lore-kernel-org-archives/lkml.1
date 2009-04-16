Return-Path: <linux-kernel-owner+w=401wt.eu-S1755534AbZDPOX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534AbZDPOX1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 10:23:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbZDPOXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 10:23:18 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:60259 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbZDPOXR (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 10:23:17 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, hpa@zytor.com, mingo@elte.hu,
       tglx@linutronix.de, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, davej@redhat.com
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
In-Reply-To: Your message of "Wed, 15 Apr 2009 14:23:26 PDT."
             <20090415.142326.97287514.davem@davemloft.net>
From: Valdis.Kletnieks@vt.edu
References: <alpine.LFD.2.00.0904151013260.4132@localhost.localdomain> <49E62BD5.6090508@zytor.com> <alpine.LFD.2.00.0904151241490.4132@localhost.localdomain>
            <20090415.142326.97287514.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1239887097_4039P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 16 Apr 2009 09:04:57 -0400
Message-ID: <43197.1239887097@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1239887097_4039P
Content-Type: text/plain; charset=us-ascii

On Wed, 15 Apr 2009 14:23:26 PDT, David Miller said:
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Wed, 15 Apr 2009 12:43:02 -0700 (PDT)
> 
> > And if it _is_ obvious, then the mechanical "Impact:" thing is pointless.
> > 
> > In other words - in neither case does it actually help anything at all. 
> > It's only distracting noise.
> 
> FWIW I find the Impact: blurbs highly annoying too.  Just freakin'
> say what the damn patch does in the commit message.
> 
> If a person can't be bothered to skim the commit message text,
> this Impact: tag only gives them a false sense of understanding
> what the change does.

Maybe we can use it to flag security fixes, to appease the people complaining
they can't find the security fixes without reading the commit message text. ;)


--==_Exmh_1239887097_4039P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJ5yz5cC3lWbTT17ARAv4wAJ0bmj0Y1Er7Vvuf9rbhTnKn1d4QVACg+YDc
gJ7Vuj5dbqcNamVjaQ8eF1k=
=tW5E
-----END PGP SIGNATURE-----

--==_Exmh_1239887097_4039P--
