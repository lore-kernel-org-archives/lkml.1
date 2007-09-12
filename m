Return-Path: <linux-kernel-owner+w=401wt.eu-S968091AbXILNxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968091AbXILNxO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 09:53:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763725AbXILNw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 09:52:59 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:23293 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758384AbXILNw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 09:52:58 -0400
Message-ID: <46E7EF35.5000002@trausch.us>
Date: Wed, 12 Sep 2007 09:52:53 -0400
From: "Michael B. Trausch" <mike@trausch.us>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
To: Stef Epardaud <stef@epardaud.net>
CC: linux-kernel@vger.kernel.org
Subject: [OT] Ubuntu GG 2.6.22 (Was: Re: Filesystem silent crash with EXT3)
References: <20070912120203.GA23510@inforealm.org>
In-Reply-To: <20070912120203.GA23510@inforealm.org>
X-Enigmail-Version: 0.95.2
OpenPGP: id=19C59A30
Content-Type: multipart/signed; micalg=pgp-ripemd160;
 protocol="application/pgp-signature";
 boundary="------------enig380E2CE7735E2EB514D67C4C"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig380E2CE7735E2EB514D67C4C
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Stef Epardaud, on 09/12/2007 08:02 AM said:
>
> Hello,
> I am not subscribed to this list, so please CC me on replies.
> I have just suffered from a filesystem crash on my laptop. It's an x86
> running linux 2.6.22 from Ubutu latest gutsy.
>

(I am cc:ing the list so that this person does not get several multiple
replies.  Also, I am making the assumption, Stef, that you are not
running a vanilla kernel that you built yourself from the kernel sources
and that you are running the Ubuntu stock kernel.)

Please go to #ubuntu+1 on irc.freenode.net for issues with your Ubuntu
Gutsy Gibbon prerelease system.  For starters, the kernel that comes
with Ubuntu is not the vanilla Linux kernel, it has patches and added
and removed things to it---like nearly all distribution kernels.

Secondly, the Gutsy Gibbon is not yet released for public consumption.
It is in a prerelease state, and as such, if you're running it, and you
encounter issues, please file bugs with Ubuntu
(http://www.launchpad.net/), where they will be far more receptive to
such information.  However, they will not directly support you---you
chose to run a prerelease system; they'll tell you that if it breaks
your system you get to keep all the pieces.  Once the Gibbon is
released, though, you can use it with the backing of the regular Ubuntu
community and it will be supported.

That having been said, you may not want to run prerelease software that
is known to be unstable if you don't have the time (or the ability) to
troubleshoot and file a detailed bug report during the prerelease state.
 At any rate, this list is not the place to air your problems with the
Gutsy Gibbon.

	HTH,
	Mike

--=20
Michael B. Trausch               Internet Mail & Jabber: mike@trausch.us
Phone:  (404) 592-5746 x1                         http://www.trausch.us/
Mobile: (678) 522-7934             VoIP: 6453@sip.trausch.us, 861384@fwd
Pidgin 2.1.1 and plugins for Ubuntu Feisty! http://www.trausch.us/pidgin


--------------enig380E2CE7735E2EB514D67C4C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFG5+820kE/IBnFmjARA4SEAJ9muXKZ31PzQe0Kb6SN2osbhK+yyACfSKAZ
mQfQCY5a6la5VFeM5kqaOVI=
=4NSj
-----END PGP SIGNATURE-----

--------------enig380E2CE7735E2EB514D67C4C--
