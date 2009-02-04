Return-Path: <linux-kernel-owner+w=401wt.eu-S1755536AbZBDRuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536AbZBDRuc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 12:50:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbZBDRuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 12:50:23 -0500
Received: from ns1.suse.de ([195.135.220.2]:37648 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677AbZBDRuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 12:50:22 -0500
Date: Wed, 4 Feb 2009 09:50:16 -0800
From: Mark Fasheh <mfasheh@suse.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
       Joel Becker <joel.becker@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git patches] Ocfs2 and Configfs fixes
Message-ID: <20090204175016.GU17410@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.com>
References: <20090203212422.GT17410@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090203212422.GT17410@wotan.suse.de>
Organization: SUSE Labs, Novell, Inc
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Can you please pull again? I mistakenly included a version of the configfs
patch which is in the process of being reworked. This pull reverts it. Thank
you.
	--Mark

Please pull from 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus

to receive the following updates:

 fs/configfs/dir.c |   59 -----------------------------------------------------
 1 files changed, 0 insertions(+), 59 deletions(-)

Mark Fasheh (1):
      Revert "configfs: Silence lockdep on mkdir(), rmdir() and configfs_depend_item()"


--
Mark Fasheh
