Return-Path: <linux-kernel-owner+w=401wt.eu-S1753350AbZGVPvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbZGVPvM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 11:51:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbZGVPvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 11:51:10 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:37034 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278AbZGVPvG (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 11:51:06 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andi Kleen <andi@firstfloor.org>
Cc: Steven Whitehouse <swhiteho@redhat.com>, cluster-devel@redhat.com,
       linux-kernel@vger.kernel.org, rpurdie@rpsys.net
Subject: Re: GFS2: Add LED support to GFS2
In-Reply-To: Your message of "Wed, 22 Jul 2009 17:15:21 +0200."
             <20090722151521.GB6035@basil.fritz.box>
From: Valdis.Kletnieks@vt.edu
References: <1248260198.3456.4.camel@localhost.localdomain> <87k5203hdx.fsf@basil.nowhere.org> <1248274288.3298.5.camel@localhost.localdomain> <20090722145534.GA6035@basil.fritz.box> <1248274951.3298.11.camel@localhost.localdomain>
            <20090722151521.GB6035@basil.fritz.box>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1248277845_3794P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 22 Jul 2009 11:50:45 -0400
Message-ID: <23263.1248277845@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1248277845_3794P
Content-Type: text/plain; charset=us-ascii

On Wed, 22 Jul 2009 17:15:21 +0200, Andi Kleen said:

> So have some sysfs file where you echo mount points into to enable
> LED activity.
> 
> Ok that would be a little clumpsy for a "10 million bind mounts" case,
> but presumably that's very rare and they can still make it work.

Might be interesting for a file server, allow for a Connection-Machine
style front panel... ;)

--==_Exmh_1248277845_3794P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKZzVVcC3lWbTT17ARAgAYAKDQ59GMClum4qeL8eKr0bbblTjUXgCg1//V
F+0P6Gjii3fCOIJ0G9Lp4MI=
=pdic
-----END PGP SIGNATURE-----

--==_Exmh_1248277845_3794P--
