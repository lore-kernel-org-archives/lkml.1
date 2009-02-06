Return-Path: <linux-kernel-owner+w=401wt.eu-S1756206AbZBFNee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206AbZBFNee (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 08:34:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753737AbZBFNe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 08:34:26 -0500
Received: from mx2.redhat.com ([66.187.237.31]:57619 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605AbZBFNe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 08:34:26 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       linux-cachefs@redhat.com
Subject: FS-Cache patches version #45 released
Date: Fri, 06 Feb 2009 13:34:22 +0000
Message-ID: <27531.1233927262@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've adjusted the NFS and AFS patches that altered the fs/Kconfig as this has
now been distributed between separate fs directories.  I've also folded in a
patch to deal with a warning in the AFS code and rebased on the latest Linus
head version.

These patches are now available as:

	http://people.redhat.com/~dhowells/fscache/patches/nfs+fscache-45.tar.bz2

and I've updated my GIT tree:

	http://git.kernel.org/?p=linux/kernel/git/dhowells/linux-2.6-nfs-fscache.git;a=shortlog

David

