Return-Path: <linux-kernel-owner+w=401wt.eu-S1754935Ab0AEPul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab0AEPul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 10:50:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754867Ab0AEPuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 10:50:40 -0500
Received: from cantor.suse.de ([195.135.220.2]:60325 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752837Ab0AEPuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 10:50:39 -0500
Date: Tue, 5 Jan 2010 16:50:38 +0100
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jonathan Nieder <jrnieder@gmail.com>, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT PULL] kbuild fix for 2.6.33
Message-ID: <20100105155038.GA20834@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull this to fix build with /bin/sh -> dash (as used in Ubuntu).

Thanks!
Michal

The following changes since commit 45d28b097280a78893ce25a5d0db41e6a2717853:
  Linus Torvalds (1):
        Merge branch 'reiserfs/kill-bkl' of git://git.kernel.org/.../frederic/random-tracing

are available in the git repository at:

  git://repo.or.cz/linux-kbuild.git for-33

Jonathan Nieder (1):
      kbuild: really fix bzImage build with non-bash sh

 scripts/Makefile.lib |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)
