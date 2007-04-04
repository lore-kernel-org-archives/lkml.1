Return-Path: <linux-kernel-owner+w=401wt.eu-S1752350AbXDDR6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350AbXDDR6s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 13:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752345AbXDDR6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 13:58:48 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:58154 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbXDDR6q (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 13:58:46 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc5-mm4
In-Reply-To: Your message of "Tue, 03 Apr 2007 20:37:42 PDT."
             <46131D86.4070607@oracle.com>
From: Valdis.Kletnieks@vt.edu
References: <20070402224745.71a25af7.akpm@linux-foundation.org> <24083.1175650554@turing-police.cc.vt.edu> <20070403192004.986b44ec.randy.dunlap@oracle.com> <4963.1175654767@turing-police.cc.vt.edu>
            <46131D86.4070607@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1175709308_9478P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 04 Apr 2007 13:55:08 -0400
Message-ID: <10023.1175709308@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1175709308_9478P
Content-Type: text/plain; charset=us-ascii

On Tue, 03 Apr 2007 20:37:42 PDT, Randy Dunlap said:
>
> Good luck.  But the symbols are there.  Just use left/right arrow keys
> to scroll the display left/right and you can see them.  Now if you just
> had that indicator to tell you that you Need to scroll to see more text...

Exactly. :)  I had the incredible bad luck that the line got cut off at the
end of a CONFIG_ symbol that made sense - if it had showed up *half* a symbol,
I'd have gone investigating. ;) (Even a '>' or '<' saying data offscreen to
right or left would be sufficient, if somebody wants a small but productive
kernel (config system actually) task to hack on.)

I'd code it myself, but I have an SL8500 to install, and need to figure out
how my laptop made it into the bag this morning still up and running (I hit
the power button, it seemed to power down - blank screen, power light off,
but syslog msgs prove it was up and running for another 4 hours before it
shut down on a thermal check...)


--==_Exmh_1175709308_9478P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGE+Z8cC3lWbTT17ARAq7OAKCRq4uNygvLZIj9CpB4qK+Hqds2ugCg31NG
5DMUwX/eK66qHlI5yFi2chw=
=uWM7
-----END PGP SIGNATURE-----

--==_Exmh_1175709308_9478P--
