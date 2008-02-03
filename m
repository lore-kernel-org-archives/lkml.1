Return-Path: <linux-kernel-owner+w=401wt.eu-S935385AbYBCA7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935385AbYBCA7i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 19:59:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765667AbYBCA7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 19:59:31 -0500
Received: from briare1.fullpliant.org ([81.56.244.40]:48617 "HELO
	briare1.fullpliant.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751031AbYBCA7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 19:59:30 -0500
X-Greylist: delayed 437 seconds by postgrey-1.27 at vger.kernel.org; Sat, 02 Feb 2008 19:59:30 EST
From: Hubert Tonneau <hubert.tonneau@fullpliant.org>
To: linux-kernel@vger.kernel.org
Subject: Desparately wanted: intelfb modesetting in mainline
Date: Sun, 03 Feb 2008 01:58:16 GMT
Message-ID: <081P9H411@briare1.fullpliant.org>
X-Mailer: Pliant 96
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a probable result of Intel opening specifications,
it is now fairly easy to buy a business computer that will run Linux
without loosing weeks hacking to get it up and running:
just go with an intel graphic board since Intel X11 driver now works just fine.

Well, this apply only if you run mainstream Linux, that is X11 for the
graphics, because if your application relies on the framebuffer,
we are still at far west time.

Now that Linux is getting more professional with plenty of hackers paid to do
so, it would be nice to include active minimal completeness of the system goal,
as opposed to just passive filtering of preposed patches,
because without it, small more inovative projects (that sit on top of the
kernel instead of beeing kernel rated projects) have a hard time,
so that Linux behaviour is not that different from closed one:
favor the mainstream and ignore small players at the expense of inovation.

Same applies for user land part of some drivers. The current situation is
complete lack of consistency so that getting a working kernel (which nowdays
means kernel + many user land helpers) get's more and more complicated year
after year, as opposed to early days where user land was just achieving a
fiew simple IOCTLs to configure.
It is very understandable to reject many part of drivers to user land to avoid
too much code (with nasty well known side effects) in the kernel, but just
saying that since it is user land it does not have to follow any rule (such as
beeing part of the kernel source and linking only to kernel source provided
libraries) just means lot of work to distributions (so death of small ones
that are not just a recent fork of a big one)

