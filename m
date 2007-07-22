Return-Path: <linux-kernel-owner+w=401wt.eu-S1758451AbXGVRTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758451AbXGVRTT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 13:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750940AbXGVRTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 13:19:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:34528 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbXGVRTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 13:19:06 -0400
Date: Sun, 22 Jul 2007 17:19:01 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.4.34.6
Message-ID: <20070722171901.GA13324@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

I've just released Linux 2.4.34.6. I intend it to be the last 2.4.34
version, unless something critical happens before 2.4.35. Given the
very small number of changes between versions, maintenance of -stable
will end for 2.4.34 and continue with 2.4.35 during 2.4.36-preX.

Willy
--

The patch and changelog will appear soon at the following locations:
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/patch-2.4.34.6.bz2
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/ChangeLog-2.4.34.6

Git repository:
   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-v2.4.34.y.git
  http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-v2.4.34.y.git

Git repository through the gitweb interface:
  http://git.kernel.org/?p=linux/kernel/git/stable/linux-v2.4.34.y.git



Summary of changes from v2.4.34.5 to v2.4.34.6
============================================

Lior Dotan (1):
      Fix divide by 0 in vegas_cong_avoid()

PaX Team (1):
      random device reseed bugfix, possibly security problem

Willy Tarreau (1):
      Change VERSION to 2.4.34.6

