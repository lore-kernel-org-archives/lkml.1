Return-Path: <linux-kernel-owner+w=401wt.eu-S933816AbXIKVKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933816AbXIKVKz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 17:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764905AbXIKVKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 17:10:40 -0400
Received: from smtp-0-2.linuxrulz.org ([66.197.170.246]:59031 "EHLO
	smtp-0-2.linuxrulz.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764885AbXIKVKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 17:10:39 -0400
Message-ID: <46E7043C.4080905@lbsd.net>
Date: Tue, 11 Sep 2007 21:10:20 +0000
From: Nigel Kukard <nkukard@lbsd.net>
User-Agent: Thunderbird 2.0.0.6 (X11/20070727)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] BootUtils v0.0.7
X-Enigmail-Version: 0.95.0
OpenPGP: id=27702C4E;
	url=pgpkeys.mit.edu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Project Description:
BootUtils is a collection of utilities to facilitate booting of modern
Kernel 2.6 based systems. BootUtils is designed for initramfs, although
volunteers to add support for initrd are welcome. The process of finding
the root volume either by label or explicit label= on the kernel command
line, mounting it and 'switchroot'ing is automated. BootUtils can also
drop to emergency shell if the root volume cannot be mounted. Why not
even start sshd and allow admin login if the box is in a remote location?

Features:
* Automatic detection of root volume by label or explicit kernel
commandline option
* Supports ext2, ext3, jfs, reiserfs and xfs
* Emergency shell dropping in the case of a root volume problem
* Distribution independant

Changes:
* This release adds a raidscan tool that initiates the kernel's software
raid auto-detect functionality.
* It also adds some verbosity to switchroot.

Website:
http://www.freshmeat.net/projects/bootutils/
