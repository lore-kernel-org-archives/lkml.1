Return-Path: <linux-kernel-owner+w=401wt.eu-S1161303AbXDVQGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161303AbXDVQGK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 12:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161305AbXDVQGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 12:06:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:60542 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161303AbXDVQGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 12:06:08 -0400
Date: Sun, 22 Apr 2007 16:06:06 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.4.34.4
Message-ID: <20070422160606.GA23106@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I've just released Linux 2.4.34.4, previous one did not build.
Thanks to Urs Thuermann for reporting the problem (and fix).

The patch and changelog will appear soon at the following locations:
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/patch-2.4.34.4.bz2
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/ChangeLog-2.4.34.4

Git repository:
   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-v2.4.34.y.git
  http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-v2.4.34.y.git

Git repository through the gitweb interface:
  http://git.kernel.org/?p=linux/kernel/git/stable/linux-v2.4.34.y.git



Summary of changes from v2.4.34.3 to v2.4.34.4
============================================

Urs Thermann (1):
      recent patch to fib_semantics broke build

Willy Tarreau (1):
      Change VERSION to 2.4.34.4

