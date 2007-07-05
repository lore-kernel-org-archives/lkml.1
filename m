Return-Path: <linux-kernel-owner+w=401wt.eu-S1760457AbXGER5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760457AbXGER5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 13:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758820AbXGER5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 13:57:22 -0400
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1701 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758761AbXGER5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 13:57:21 -0400
Date: Thu, 5 Jul 2007 19:55:31 +0200
From: Erik Mouw <mouw@nl.linux.org>
To: Theodore Tso <tytso@mit.edu>
Cc: alan <alan@clueserver.org>, J?rn Engel <joern@logfs.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jack Stone <jack@hawkeye.stone.uk.eu.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk
Subject: Re: Versioning file system
Message-ID: <20070705175531.GB5179@gateway.home>
References: <46731169.2090002@hawkeye.stone.uk.eu.org> <467314E2.9010306@zytor.com> <Pine.LNX.4.64.0706151547200.27993@blackbox.fnordora.org> <20070616145337.GA13391@lazybastard.org> <20070618094524.GF5181@schatzie.adilger.int> <20070618140143.GD30244@thunk.org> <Pine.LNX.4.64.0706180907580.22137@blackbox.fnordora.org> <20070618172955.GB24189@thunk.org> <20070704173234.GB26201@gateway.home> <20070704204759.GA341@thunk.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3lcZGd9BuhuYXNfi"
Content-Disposition: inline
In-Reply-To: <20070704204759.GA341@thunk.org>
Organization: Eric Conspiracy Secret Labs
X-Eric-Conspiracy: There is no conspiracy!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--3lcZGd9BuhuYXNfi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 04, 2007 at 04:47:59PM -0400, Theodore Tso wrote:
> On Wed, Jul 04, 2007 at 07:32:34PM +0200, Erik Mouw wrote:
> > (sorry for the late reply, just got back from holiday)
> >=20
> > On Mon, Jun 18, 2007 at 01:29:56PM -0400, Theodore Tso wrote:
> > > As I mentioned in my Linux.conf.au presentation a year and a half ago,
> > > the main use of Streams in Windows to date has been for system
> > > crackers to hide trojan horse code and rootkits so that system
> > > administrators couldn't find them.  :-)
> >=20
> > The only valid use of Streams in Windows I've seen was a virus checker
> > that stored a hash of the file in a separate stream. Checking a file
> > was a matter of rehashing it and comparing against the hash stored in
> > the special hash data stream for that particular file.
>=20
> And even that's not a valid use.  All the virus would have to do is to
> infect the file, and then update the "special hash data stream".  Why
> is it that when programmers are told about streams as a potential
> technology choice, it makes their thinking become fuzzy?  :-)

I meant valid like "not used as malware". I agree a virus could
recompute the hash and go unnoticed.


Erik

--=20
They're all fools. Don't worry. Darwin may be slow, but he'll
eventually get them. -- Matthew Lammers in alt.sysadmin.recovery

--3lcZGd9BuhuYXNfi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGjTCT/PlVHJtIto0RArMcAKCPz7VUSTZ5dvHHuwBCm5h1VWrC/wCbBApP
292N0mU4iqQPoP28tu94Nvg=
=mqCX
-----END PGP SIGNATURE-----

--3lcZGd9BuhuYXNfi--
