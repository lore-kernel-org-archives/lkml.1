Return-Path: <linux-kernel-owner+w=401wt.eu-S1751752AbXDHTLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752AbXDHTLK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 15:11:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828AbXDHTLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 15:11:10 -0400
Received: from h80ad276f.async.vt.edu ([128.173.39.111]:58898 "EHLO
	h80ad276f.async.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbXDHTLJ (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 15:11:09 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Rene Rebe <rene@exactcode.de>
Cc: Kyle Moffett <mrmacman_g4@mac.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andi Kleen <ak@suse.de>, "Brown, Len" <len.brown@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.21-rc5: Thinkpad X60 gets critical thermal shutdowns
In-Reply-To: Your message of "Mon, 02 Apr 2007 10:35:40 +0200."
             <200704021035.40672.rene@exactcode.de>
From: Valdis.Kletnieks@vt.edu
References: <460E0158.7090705@goop.org> <8393D4C0-57C5-4CD2-8CA4-E4241E74FB4E@mac.com>
            <200704021035.40672.rene@exactcode.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1176059397_28267P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 08 Apr 2007 15:09:57 -0400
Message-ID: <28333.1176059397@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1176059397_28267P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, 02 Apr 2007 10:35:40 +0200, Rene Rebe said:

(Sorry for the late reply..)

> IIRC a MSI Megabook S270 (I formerly owned) BIOS notifies this
> =22Critical temperature reached (128C)=22 when the battery run empty
> when the OS did no action due to battery low indications. I guess
> the BIOS people thought this is a good last resort to let the OS
> really shutdown before the box just turns off.

It's not just MSI - I recently managed to put a Dell Latitude D820 into i=
ts bag
while still running, where it babbled to itself running on the warm side =
for
several hours.  When I finally did get it out, it *was* quite hot to the =
touch,
but I was amazed that it managed to run the battery down to somewhere und=
er 4%
(which took some 4 or 5 hours) and then throw the thermal check that made=
 it
shut down - quite the coincidence indeed.

However, =22ran warm but tolerable and then used the thermal to shut down=
 when
the battery failed=22 matches the symptoms much better....


--==_Exmh_1176059397_28267P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGGT4FcC3lWbTT17ARAhUrAJwJSoCK3homnoc3dhaKTZh0mIVC5ACeIvXr
TMz47x5h/nNyv5nuuUXZFYM=
=NvHm
-----END PGP SIGNATURE-----

--==_Exmh_1176059397_28267P--
