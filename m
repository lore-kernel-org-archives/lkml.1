Return-Path: <linux-kernel-owner+w=401wt.eu-S1754706AbYIHOBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbYIHOBY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 10:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbYIHOBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 10:01:14 -0400
Received: from josefsipek.net ([141.211.133.196]:36578 "EHLO josefsipek.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541AbYIHOBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 10:01:13 -0400
X-Greylist: delayed 508 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Sep 2008 10:01:13 EDT
Date: Mon, 8 Sep 2008 09:52:44 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
To: Git Mailing List <git@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       guilt@lists.josefsipek.net
Cc: Brandon Philips <brandon@ifup.org>
Subject: [ANNOUNCE] Guilt v0.31
Message-ID: <20080908135244.GB27550@josefsipek.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guilt v0.31 is available for download.

Guilt (Git Quilt) is a series of bash scripts which add a Mercurial
queues-like functionality and interface to git.

Tarballs:
http://www.kernel.org/pub/linux/kernel/people/jsipek/guilt/

Git repo:
git://git.kernel.org/pub/scm/linux/kernel/git/jsipek/guilt.git


This is a mostly bugfixes-only release to get the fixes that accumulated
over the past several months out of the door.

As always, patches, and other feedback is welcome.

Josef "Jeff" Sipek.

------------

Changes since v0.30:

Alan Jenkins (3):
      Better "patch does not exist" checks
      guilt-diff: allow paths
      guilt-diff: behave sanely if no patch applied

Eric Sandeen (1):
      regression: fix failure with Git 1.5.5

Jonas Fonseca (3):
      Documentation: rename guiltlink macro to linkguilt
      Documentation: improve AsciiDoc formatting of lists in guilt(7)
      Documentation: customized the manpage headers to include version info

Josef 'Jeff' Sipek (3):
      Documentation: add proper 'linkguilt's
      patchbomb: fix bashism
      Guilt v0.31

Shawn Starr (1):
      guilt: Fix git version detection on Debian

Theodore Ts'o (2):
      must_commit_first: Make sure the index is up to date
      Make guilt work even after git-sh-setup is moved out of the user's path

-- 
Linux, n.:
  Generous programmers from around the world all join forces to help
  you shoot yourself in the foot for free. 
