Return-Path: <linux-kernel-owner+w=401wt.eu-S1751486AbXBCUKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486AbXBCUKr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 15:10:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbXBCUKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 15:10:47 -0500
Received: from hera.kernel.org ([140.211.167.34]:41645 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486AbXBCUKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 15:10:46 -0500
Date: Sat, 3 Feb 2007 20:10:45 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Linux 2.4.34.1
Message-ID: <20070203201045.GA29991@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

activity has been very calm for 2.4 since 2.4.34. Three minor fixes
were pending, and I finally decided to release 2.4.34.1 with them
instead of keeping them in the fridge. Upgrade is recommended for
users of smbfs with unix extension, since a security fix in 2.4.34
broke symlinks. Special thanks to Dann Frazier, Santiago Garcia
and Grant Coady who did the boring work of tracking and fixing the
problem.

The files are located at the usual places. Please give it some time
to sync between the servers, and preferably use ftp2.kernel.org.

Regards,
Willy

Summary of changes from v2.4.34 to v2.4.34.1
============================================

Christian Praehauser (1):
      [NET] ethernet: Fix first packet goes out with MAC 00:00:00:00:00:00

dann frazier (1):
      smbfs: fix problems introduced by last security backport

Oliver Neukum (1):
      proper locking on disconnect for mdc800

Willy Tarreau (1):
      Change VERSION to 2.4.34.1

