Return-Path: <linux-kernel-owner+w=401wt.eu-S1752866AbZIZP4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbZIZP4S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 11:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752128AbZIZP4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 11:56:18 -0400
Received: from nfitmail.nfit.au.dk ([130.225.31.129]:58618 "EHLO
	smtp.nfit.au.dk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751904AbZIZP4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 11:56:17 -0400
X-Greylist: delayed 595 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Sep 2009 11:56:17 EDT
To: gnome-announce@gnome.org, linux-kernel@vger.kernel.org
Subject: Announce: Sysprof 1.1.2 CPU profiler for Linux
From: Soeren Sandmann <sandmann@daimi.au.dk>
Date: 26 Sep 2009 17:46:23 +0200
Message-ID: <ye8bpkxemk0.fsf@camel21.daimi.au.dk>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-NFIT-RelayAddr: 130.225.16.140
X-NFIT-Solido-Score: 0.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sysprof 1.1.2 is now available. This is a development release leading
up to a stable 1.2.0 release.

Sysprof is a sampling system-wide CPU profiler for Linux.  This
version is based on the perf counter interface in 2.6.31 kernels and
will not work with earlier kernels.

Major new features since version 1.0:

  * Commandline interface, [Lorenzo Colitti]

  * Stacktraces for both kernel and userspace

  * More accurate accounting when processes rapidly appear or
    disappear.

  * Profiles can be cutted and pasted 

  * Improved performance


Version 1.1.2 is a development release. Please report bugs to
sandmann@daimi.au.dk.


Download:

        http://www.daimi.au.dk/~sandmann/sysprof/sysprof-1.1.2.tar.gz


Git:

        git://git.gnome.org/sysprof



Thanks,
Soren
