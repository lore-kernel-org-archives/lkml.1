Return-Path: <linux-kernel-owner+w=401wt.eu-S932113AbXCXIaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113AbXCXIaY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 04:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932274AbXCXIaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 04:30:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:39072 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932113AbXCXIaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 04:30:23 -0400
Date: Sat, 24 Mar 2007 08:30:20 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.4.34.2
Message-ID: <20070324083020.GA11427@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I've just released Linux 2.4.34.2.

Only two fixes here, one from Pete Zaitcev to support USB high-speed HID,
required by at least an Avocent KVM, and one for a user-triggerable bug
in IPv6.

The patch and changelog will appear soon at the following locations:
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/patch-2.4.34.2.bz2
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/ChangeLog-2.4.34.2

Git repository:
   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-v2.4.34.y.git
  http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-v2.4.34.y.git

Git repository through the gitweb interface:
  http://git.kernel.org/?p=linux/kernel/git/stable/linux-v2.4.34.y.git



Summary of changes from v2.4.34.1 to v2.4.34.2
============================================

Pete Zaitcev (1):
      usb 2.4: Support high-speed HID

Willy Tarreau (2):
      IPV6: ipv6_fl_socklist is inadvertently shared.
      Change VERSION to 2.4.34.2

