Return-Path: <linux-kernel-owner+w=401wt.eu-S1755707AbYEIIFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707AbYEIIFE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 04:05:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755010AbYEIIEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 04:04:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943AbYEIIEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 04:04:46 -0400
Message-ID: <482404E9.3030005@redhat.com>
Date: Fri, 09 May 2008 01:01:45 -0700
From: Ulrich Drepper <drepper@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH 02/18] flag parameters: paccept
References: <200805062118.m46LI7SS004041@devserv.devel.redhat.com> <20080508153822.0c4dd6e9.akpm@linux-foundation.org>
In-Reply-To: <20080508153822.0c4dd6e9.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Andrew Morton wrote:
> Ah, you must have prepared the patches against something prehistoric like
> 2.6.25.  Please prefer to prepare 2.6.x patches against the 2.6.x tree, not
> the 2.6.x-1 tree?

Well, pre-historic == before 2008-4-30.  That's apparently when Roland's
patch to change this went in.  Yes, I wrote the code before that day and
didn't notice the pselect implementation changed.  Sorry.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iEYEARECAAYFAkgkBOkACgkQ2ijCOnn/RHSrgACeP1pFdt4QDnE6OOJHy/d7D5H+
sHQAoLpnEb3FwKh89viFtWXOVfDaVyWf
=tiZM
-----END PGP SIGNATURE-----
