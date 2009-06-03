Return-Path: <linux-kernel-owner+w=401wt.eu-S1757983AbZFCR1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983AbZFCR1s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 13:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755266AbZFCR1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 13:27:40 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:44453 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082AbZFCR1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 13:27:39 -0400
Message-ID: <4A26B284.3060809@novell.com>
Date: Wed, 03 Jun 2009 13:27:32 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org, mst@redhat.com
Subject: Re: [KVM-RFC PATCH 2/2] kvm: use POLLHUP to close an irqfd instead
 of an explicit ioctl
References: <20090602151135.29746.91320.stgit@dev.haskins.net> <20090602151538.29746.40356.stgit@dev.haskins.net> <20090602180256.GD6743@linux.vnet.ibm.com> <4A256E12.9060301@novell.com> <20090602220157.GF6743@linux.vnet.ibm.com> <4A25D799.10604@novell.com> <20090603150439.GB6640@linux.vnet.ibm.com>
In-Reply-To: <20090603150439.GB6640@linux.vnet.ibm.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig25CB41F09E6F3EA94C350FDF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig25CB41F09E6F3EA94C350FDF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable


Thanks again for the review, Paul.  IIUC, you think the design is ok as
it is.

Davide,
   In light of this, would you like to submit patch 1/2 formally with
your SOB at your earliest convenience?  Or would you prefer that I
submit it and you can simply ack it?  Either is fine with me.

-Greg


--------------enig25CB41F09E6F3EA94C350FDF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkomsokACgkQlOSOBdgZUxlbYQCeKTTQYgdOxIStBPhF54zmgcTK
kzEAmgOB5Fu09ghDYLgbVuZtuWMSy7bh
=532n
-----END PGP SIGNATURE-----

--------------enig25CB41F09E6F3EA94C350FDF--
