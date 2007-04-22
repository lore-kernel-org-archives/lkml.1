Return-Path: <linux-kernel-owner+w=401wt.eu-S965626AbXDVKK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965626AbXDVKK7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 06:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754171AbXDVKK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 06:10:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:58656 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754168AbXDVKK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 06:10:58 -0400
Date: Sun, 22 Apr 2007 10:10:57 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.4.34.3
Message-ID: <20070422101057.GA11893@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've just released Linux 2.4.34.3.

Nothing critical, just a bunch of bugfixes and small security fix.

The patch and changelog will appear soon at the following locations:
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/patch-2.4.34.3.bz2
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/ChangeLog-2.4.34.3

Git repository:
   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-v2.4.34.3.y.git
  http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-v2.4.34.3.y.git

Git repository through the gitweb interface:
  http://git.kernel.org/?p=linux/kernel/git/stable/linux-v2.4.34.3.y.git

Fixed in this version :
  CVE-2007-1353 : Bluetooth: L2CAP and HCI setsockopt() information leaks

Summary of changes from v2.4.34.2 to v2.4.34.3
============================================

Willy Tarreau (6):
      [DECNet] fib: Fix out of bound access of dn_fib_props[]
      [IPv4] fib: Fix out of bound access of fib_props[]
      [PPP]: Don't leak an sk_buff on interface destruction.
      Fix TCP receiver side SWS handling
      Bluetooth: L2CAP and HCI setsockopt() information leaks (CVE-2007-1353)
      Change VERSION to 2.4.34.3

