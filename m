Return-Path: <linux-kernel-owner+w=401wt.eu-S1760595AbXJMOlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760595AbXJMOlo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 10:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754522AbXJMOlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 10:41:37 -0400
Received: from 1wt.eu ([62.212.114.60]:2867 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754028AbXJMOlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 10:41:36 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20071013142822.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 13 Oct 2007 16:28:22 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [2.6.20.21 review 00/35] 2.6.20.21 -stable review
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the review cycle for the stable 2.6.20.21
kernel release. This version catches up with 2.6.22.9, and 35
patches will be posted as a response to this message. I tried
hard to trim the patches to a minimally reasonable set, and
unless I have introduced a big regression or build error, this
version will remain the last 2.6.20.x (at least from me).

2.6.23.1 is already there, 2.6.22.9 is quite clean, 2.6.16.54
still lives, there is no reason to maintain a fourth branch.

The following security issues are solved :
  CVE-2007-3104: store sysfs inode nrs in s_ino to avoid readdir oopses
  CVE-2007-4571: Convert snd-page-alloc proc file to use seq_file

No known vulnerability fix is pending anymore.

The rolled up patch can be found here :
   ftp.kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.20.21-rc1.gz

Responses should be made by October 17, 2007, 19:00:00 UTC.
Anything received after that time might be too late.

Thanks,
Willy

