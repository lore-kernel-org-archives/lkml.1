Return-Path: <linux-kernel-owner+w=401wt.eu-S1757707AbYL1XEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757707AbYL1XEG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 18:04:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757510AbYL1XDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 18:03:52 -0500
Received: from tundra.namei.org ([65.99.196.166]:4923 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757501AbYL1XDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 18:03:50 -0500
Date: Mon, 29 Dec 2008 10:03:39 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [GIT] security/smack update for 2.6.29
Message-ID: <alpine.LRH.1.10.0812291001090.12910@tundra.namei.org>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull the bugfix for Smack per below.

The following changes since commit 541ef5cbb8e68189d47272cea52a69abc30259bc:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../geert/linux-m68k

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6 for-linus

James Morris (1):
      Merge branch 'next' into for-linus

Sergio Luis (1):
      smackfs: check for allocation failures in smk_set_access()

 security/smack/smackfs.c |   20 ++++++++++++++++----
 1 files changed, 16 insertions(+), 4 deletions(-)



-- 
James Morris
<jmorris@namei.org>
