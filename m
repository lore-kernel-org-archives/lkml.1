Return-Path: <linux-kernel-owner+w=401wt.eu-S1161220AbXBUNTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161220AbXBUNTr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 08:19:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161221AbXBUNTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 08:19:47 -0500
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:58332 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161220AbXBUNTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 08:19:45 -0500
X-Greylist: delayed 345 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Feb 2007 08:19:45 EST
X-ORBL: [67.67.197.253]
Date: Wed, 21 Feb 2007 07:06:14 -0600
From: Michael Halcrow <lkml@halcrow.us>
To: Dmitriy Monakhov <dmonakhov@sw.ru>
Cc: linux-kernel@vger.kernel.org, ecryptfs-devel@lists.sourceforge.net,
       devel@openvz.org
Subject: Re: [Ecryptfs-devel] [PATCH] ecryptfs lower_file largefile issue
Message-ID: <20070221130614.GN10765@halcrow.us>
Reply-To: Michael Halcrow <lkml@halcrow.us>
References: <871wkju8md.fsf@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871wkju8md.fsf@sw.ru>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: RIPEMD160

On Wed, Feb 21, 2007 at 01:07:22PM +0300, Dmitriy Monakhov wrote:
> Where is largefile issue in ecryptfs.

Thanks for your thorough work on resolving such issues. We will
integrate your patches and testcases into the next release as soon as
we get a chance to review and test.

Mike
.___________________________________________________________________.
                         Michael A. Halcrow                          
       Security Software Engineer, IBM Linux Technology Center       
GnuPG Fingerprint: 419C 5B1E 948A FA73 A54C  20F5 DB40 8531 6DCA 8769

"To prohibit sharing software is to cut the bonds of society."       
 - Richard Stallman

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iQEVAwUBRdxDsdtAhTFtyodpAQPT0wf/amu/FboyQXHXwnn7pUEdPqqkxXpbZGrR
L8hknVilgVA8pvgK/RrUNuakrHRWZTBokbSbiUA/xgpHlUTHa6T3VE/JOe5pLzG+
vDEo8+Ya+yjRAMJ/970oLz1T4sUXvalgJlYRaKKqKEsZmFIQwMKoK7lmc+Th+p2J
R/ZfJ3olWmskPMlLHhN4j9EEVoAGQLUqiH+bBkx4AqLJNVq9S69fFBwGFVk4t+/y
Z6KJNhJsjHnOj6ADjSlObXmB5JFIWsUl4P0fouELB4lxTYh1C42S0hy5Pl60Sq1o
MrmXIvkAdm1klYwbhaF174zu2XDzDJICXq4475v3WWVxT65HYkanMQ==
=3zMo
-----END PGP SIGNATURE-----
