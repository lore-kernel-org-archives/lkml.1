Return-Path: <linux-kernel-owner+w=401wt.eu-S1754017Ab0AHTrH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab0AHTrH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 14:47:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753520Ab0AHTrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 14:47:06 -0500
Received: from relay1.sgi.com ([192.48.179.29]:48592 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751379Ab0AHTrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 14:47:05 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201001081946.o08JksvX018976@stout.americas.sgi.com>
Date: Fri, 08 Jan 2010 13:46:54 -0600
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update 1 for 2.6.33-rc3
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a few other commits to send along but there's no sense
in waiting for them.  I forgot to send this one before; it
eliminates some i386 build warnings in certain environments.

					-Alex

The following changes since commit 74d2e4f8d79ae0c4b6ec027958d5b18058662eea:
  Linus Torvalds (1):
        Linux 2.6.33-rc3

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Dave Chinner (1):
      xfs: kill some warnings on i386 builds

 fs/xfs/linux-2.6/xfs_trace.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)
