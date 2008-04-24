Return-Path: <linux-kernel-owner+w=401wt.eu-S1756004AbYDXVgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbYDXVgq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 17:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753480AbYDXVge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 17:36:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56971 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753350AbYDXVgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 17:36:32 -0400
Message-ID: <4810FD32.3070701@redhat.com>
Date: Thu, 24 Apr 2008 14:35:46 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] socket, socketpair w/flags, accept4
References: <200804241820.m3OIKlMK017580@devserv.devel.redhat.com> <20080424215858.771f718a@the-village.bc.nu>
In-Reply-To: <20080424215858.771f718a@the-village.bc.nu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Alan Cox wrote:
> Can we also get
> the behaviour of flag inheritance and other stuff defined in any future
> API spec for this so it is consistent across platforms too - that will
> also let the new accept be used in the longer term to make portable code
> easier.

If you write it down I'll bring it forward and on the agenda for
standardization in the 201x revision.  We are not adding new
functionality in corrigendas.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFIEP0y2ijCOnn/RHQRAh5kAJ9GRZQCfxTL9mgi/UGxzowvdyLGbQCdEvHE
TmZcS+rOZcxMwpIltQYA6bI=
=IKA3
-----END PGP SIGNATURE-----
