Return-Path: <linux-kernel-owner+w=401wt.eu-S1756615AbZKBTQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615AbZKBTQP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 14:16:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755607AbZKBTQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 14:16:14 -0500
Received: from nfitmail.nfit.au.dk ([130.225.31.129]:30310 "EHLO
	smtp.nfit.au.dk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753480AbZKBTQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 14:16:14 -0500
To: linux-kernel@vger.kernel.org, gnome-announce-list@gnome.org
Cc: giallu@gmail.com
Subject: Announce: Sysprof 1.1.4 CPU profiler for Linux 
From: Soeren Sandmann <sandmann@daimi.au.dk>
Date: 02 Nov 2009 20:16:17 +0100
Message-ID: <ye8tyxc20vy.fsf@camel24.daimi.au.dk>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-NFIT-RelayAddr: 130.225.16.143
X-NFIT-Solido-Score: 0.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sysprof 1.1.4 is now available. This is a development release leading
up to a stable 1.2.0 release.

Sysprof is a sampling system-wide CPU profiler for Linux.  This
version is based on the perf counter interface in 2.6.31 kernels and
will not work with earlier kernels.

News since 1.1.2:

  - Support for hrtimer fallbacks

  - Work around the kernel producing spurious IRQ and NMI stacks

  - Misc. bug fixes


Major new features since version 1.0:

  * Commandline interface, [Lorenzo Colitti]

  * Stacktraces for both kernel and userspace

  * More accurate accounting when processes rapidly appear or
    disappear.

  * Profiles can be cutted and pasted 

  * Improved performance


Version 1.1.4 is a development release. Please report bugs to
sandmann@daimi.au.dk.


Download:

        http://www.daimi.au.dk/~sandmann/sysprof/sysprof-1.1.4.tar.gz


Git:

        git://git.gnome.org/sysprof



Thanks,
Soren
