Return-Path: <linux-kernel-owner+w=401wt.eu-S1758943AbXLPT53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758943AbXLPT53 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 14:57:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755305AbXLPT5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 14:57:22 -0500
Received: from os.eurotux.com ([216.75.63.6]:55625 "EHLO os.eurotux.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755215AbXLPT5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 14:57:21 -0500
Date: Sun, 16 Dec 2007 19:57:15 +0000
From: Luciano Rocha <luciano@eurotux.com>
To: Rafael Sisto <rafael.sisto@gmail.com>
Cc: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: shared memory
Message-ID: <20071216195715.GA10287@bit.office.eurotux.com>
Mail-Followup-To: Luciano Rocha <luciano@eurotux.com>,
	Rafael Sisto <rafael.sisto@gmail.com>,
	Linux kernel <linux-kernel@vger.kernel.org>
References: <ee3dc96c0712161151x7941e4e1y51a7631ada375c70@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
Content-Disposition: inline
In-Reply-To: <ee3dc96c0712161151x7941e4e1y51a7631ada375c70@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-03-31)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 16, 2007 at 04:51:39PM -0300, Rafael Sisto wrote:
> Hi, Im working on a project working on linux kernel 2.6.17
> I have to share memory on user level... I have to build something like
> a server process that "exports" a portion of his virtual memory, and
> other client process may ask the kernel for that memory and use it (as
> its own).
> I managed to build a structure on the kernel.

Why? Aren't SysV IPC or Posix IPC enough?

See "man shm_open", for the new Posix version, and "man shmget" for the
old SysV IPC version.

--=20
Luciano Rocha <luciano@eurotux.com>
Eurotux Inform=E1tica, S.A. <http://www.eurotux.com/>

--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHZYMbinSul6a7oB8RAjRvAJ96eW7iQVIfRg/rplJ2nTu/YkxidACePdyA
HCkyF2HF8rTmKxIBDy3vC/U=
=rc99
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
