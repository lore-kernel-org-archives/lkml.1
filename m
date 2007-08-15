Return-Path: <linux-kernel-owner+w=401wt.eu-S1758476AbXHOLJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758476AbXHOLJB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 07:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641AbXHOLIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 07:08:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:38262 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108AbXHOLIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 07:08:51 -0400
Date: Wed, 15 Aug 2007 13:08:51 +0200
From: Jan Blunck <jblunck@suse.de>
To: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       opensuse-kernel@opensuse.org, opensuse@opensuse.org
Subject: Testing the Current Upstream Kernel
Message-ID: <20070815110850.GY12730@hasse.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG
	Nuernberg)
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton has spoken at different occasions about testing of the
Linux kernel and asked users to test the current development version and
report their findings.  For our openSUSE releases we have in general a
frozen version and add only fixes for bugs that are encountered during
testing - but stay with the same version for the lifetime of a release.

With our openSUSE Build Service we build a daily kernel, where we take
nightly snapshots of the current upstream development kernel (Linus' kernel
tree linux-2.6.git) without any patches (besides those we need for building a
RPM).  We do call this the vanilla kernel. It can be downloaded from:

 http://download.opensuse.org/repositories/Kernel:/Vanilla/SUSE_Factory/

To install and use the vanilla kernel you might need to update some of your
user-space tools as well (like udev etc.). If you are running the latest
openSUSE Developer Version (aka Factory) you should already have the correct
version of tools installed.

If you test the vanilla kernel, report any problems to the Linux kernel
mailing list (for details check the FAQ at http://www.tux.org/lkml/) and not
to the openSUSE bugzilla. If you want to report problems with the RPMs itself
or have general questions about the Kernel:Vanilla project use the
opensuse-kernel@opensuse.org mailing list.

Andreas Jaeger <aj@suse.de> and Jan Blunck <jblunck@suse.de>
