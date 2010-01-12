Return-Path: <linux-kernel-owner+w=401wt.eu-S1754090Ab0ALPxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab0ALPxQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 10:53:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052Ab0ALPxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 10:53:15 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:38640 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699Ab0ALPxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 10:53:13 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Benjamin LaHaise <bcrl@lhnet.ca>
Cc: Tejun Heo <tj@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
       Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 3/7] sysfs: Keep an nlink count on sysfs directories.
In-Reply-To: Your message of "Mon, 11 Jan 2010 19:53:08 EST."
             <20100112005308.GL5524@kvack.org>
From: Valdis.Kletnieks@vt.edu
References: <m1d41g9z3q.fsf@fess.ebiederm.org> <1263241315-19499-3-git-send-email-ebiederm@xmission.com> <4B4BC683.7060508@kernel.org>
            <20100112005308.GL5524@kvack.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1263311385_4706P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 12 Jan 2010 10:49:45 -0500
Message-ID: <5460.1263311385@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020201.4B4C9A1A.01F8,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1263311385_4706P
Content-Type: text/plain; charset=us-ascii

On Mon, 11 Jan 2010 19:53:08 EST, Benjamin LaHaise said:
> 64k is too small.  10 gig interfaces can currently service 50-100k users,

I'll certainly buy that.

> each of which requires their own network device.

You throwing each user into their own separate network namespace?



--==_Exmh_1263311385_4706P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLTJoZcC3lWbTT17ARAqKQAJwM9/HnK16Gf5PtEZnJh56qSAfAkwCgvgiI
ipkbXGj9pBBTMA4lNPXHoEQ=
=iR6w
-----END PGP SIGNATURE-----

--==_Exmh_1263311385_4706P--

