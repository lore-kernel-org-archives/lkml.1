Return-Path: <linux-kernel-owner+w=401wt.eu-S1761068AbXISSCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761068AbXISSCc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 14:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750910AbXISSCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 14:02:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbXISSCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 14:02:21 -0400
Message-ID: <46F16418.3070706@redhat.com>
Date: Wed, 19 Sep 2007 11:02:00 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: netdev <netdev@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: follow-up: discrepancy with POSIX
References: <46F13E8B.4050309@redhat.com> <p73sl5aveqh.fsf@bingen.suse.de> <46F15305.2030507@redhat.com> <20070919172653.GB18045@one.firstfloor.org> <46F1608E.7060908@redhat.com> <20070919175700.GC18045@one.firstfloor.org>
In-Reply-To: <20070919175700.GC18045@one.firstfloor.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Andi Kleen wrote:
> Spec doesn't match traditional behaviour then.

Well, determining whether that's the case is part of this exercise.


> IPv4 0.0.0.0 is 
> traditionally an synonym for old style all broadcast (255.255.255.255) 
> on UDP/RAW and it's certainly possible to connect() to that. 

Where do you get this from?  And where is this implemented?  I don't
doubt it but I have to convince people to change the standard and
possibly introduce incompatibility.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFG8WQY2ijCOnn/RHQRAlsBAJ9qZRZXNN2VEy136MFIT1daHfju5ACdGiIW
k0I5e2BGRjvjbJrrAwtehqo=
=fX+i
-----END PGP SIGNATURE-----
