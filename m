Return-Path: <linux-kernel-owner+w=401wt.eu-S1758810AbXGDRec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758810AbXGDRec (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 13:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754476AbXGDReZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 13:34:25 -0400
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4379 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbXGDReZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 13:34:25 -0400
Date: Wed, 4 Jul 2007 19:32:34 +0200
From: Erik Mouw <mouw@nl.linux.org>
To: Theodore Tso <tytso@mit.edu>, alan <alan@clueserver.org>,
       J?rn Engel <joern@logfs.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Jack Stone <jack@hawkeye.stone.uk.eu.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk
Subject: Re: Versioning file system
Message-ID: <20070704173234.GB26201@gateway.home>
References: <46731169.2090002@hawkeye.stone.uk.eu.org> <467314E2.9010306@zytor.com> <Pine.LNX.4.64.0706151547200.27993@blackbox.fnordora.org> <20070616145337.GA13391@lazybastard.org> <20070618094524.GF5181@schatzie.adilger.int> <20070618140143.GD30244@thunk.org> <Pine.LNX.4.64.0706180907580.22137@blackbox.fnordora.org> <20070618172955.GB24189@thunk.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lEGEL1/lMxI0MVQ2"
Content-Disposition: inline
In-Reply-To: <20070618172955.GB24189@thunk.org>
Organization: Eric Conspiracy Secret Labs
X-Eric-Conspiracy: There is no conspiracy!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--lEGEL1/lMxI0MVQ2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

(sorry for the late reply, just got back from holiday)

On Mon, Jun 18, 2007 at 01:29:56PM -0400, Theodore Tso wrote:
> As I mentioned in my Linux.conf.au presentation a year and a half ago,
> the main use of Streams in Windows to date has been for system
> crackers to hide trojan horse code and rootkits so that system
> administrators couldn't find them.  :-)

The only valid use of Streams in Windows I've seen was a virus checker
that stored a hash of the file in a separate stream. Checking a file
was a matter of rehashing it and comparing against the hash stored in
the special hash data stream for that particular file.


Erik

--=20
They're all fools. Don't worry. Darwin may be slow, but he'll
eventually get them. -- Matthew Lammers in alt.sysadmin.recovery

--lEGEL1/lMxI0MVQ2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGi9my/PlVHJtIto0RAs/nAJ9fc2QRG3AHkVJDX47CSsLbKvyISgCfc7U4
dOWWLdzS148vGt6mMYKHmnM=
=dxs4
-----END PGP SIGNATURE-----

--lEGEL1/lMxI0MVQ2--
