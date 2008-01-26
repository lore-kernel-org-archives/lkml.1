Return-Path: <linux-kernel-owner+w=401wt.eu-S1755693AbYAZVRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbYAZVRz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 16:17:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753393AbYAZVRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 16:17:45 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:50117 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753143AbYAZVRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 16:17:45 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch] drop linux/ufs_fs.h from userspace export
Date: Sat, 26 Jan 2008 16:17:42 -0500
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200801260409.53276.vapier@gentoo.org> <20080126202322.GC28444@infradead.org>
In-Reply-To: <20080126202322.GC28444@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1450574.eI8xtYOWK6";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200801261617.43454.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1450574.eI8xtYOWK6
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Saturday 26 January 2008, Christoph Hellwig wrote:
> On Sat, Jan 26, 2008 at 04:09:52AM -0500, Mike Frysinger wrote:
> > Per previous discussions about cleaning up ufs_fs.h, people just want
> > this straight up dropped from userspace export.  The only remaining
> > consumer (silo) has been fixed a while ago to not rely on this header.
>
> Thanks!  Care to move it to fs/ufs/ while you're at it?

sure, i'll send a patch to apply after this one
-mike

--nextPart1450574.eI8xtYOWK6
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iQIVAwUAR5ujd0FjO5/oN/WBAQL9BhAAyMwLGYjkybfn9hDur/oYgjgKOk4NeH4G
GmtauvZlMLE+JaDcBMvNPBMLl1nKDrXhM7KI0tykplnBtIQM5HmCRgMiKuPUAvUL
v/Cjkr2eJDnzpqhNJ53WpWuaKn4VR/odq3JHfZ5blGTHyu93BM/0oq/+7v7d4bDk
rlknp7qcA2A9W8WT0CBLXuBD6k4N1EWhIGKUeZJzwVd3fr3AhhMHJ9NB3+/pPdTe
n8iTXdwT5hGT/eupejex+7pUuvn+jRsYwtaHB74KguIVLVVjC3xYaQoVJQPznhMe
daubV60lOwEmG035hUqkPaqqOtPXaCym1q4Bf6U9/1lvvaMrqYgU7iybpmHiI4o5
E0jMbkcPlhFwPHoCIeSiIV8CqPEPACTj+96Gad4WfgtpbhkKg8t8aH9uXzHH70i8
HrTVIn02snXKS3UkBDNV1H9pKLss/NYW8NxSuxs0PQd/HqVjwhaxjR0qvTQEZxoO
0skDUvpEo2IC9wjwdBLrUwF8s3F0F4jJsEYusMIzjhco89DrxBI1r9EjFpOhGZRc
6s6TFh0qTT1gosm7gO5Q1zygSzdOS7Y79HxBKsOZrEFcsDL9+B/c6alnXLibMYjK
pYZim9HwtBxji9JkbMZHZQ7lQfPDlxLrbr0MtJ7O/ae51kk/viMPH51Ct6PR/hlE
sIX2m1NsAjo=
=v8WS
-----END PGP SIGNATURE-----

--nextPart1450574.eI8xtYOWK6--
