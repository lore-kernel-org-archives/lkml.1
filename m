Return-Path: <linux-kernel-owner+w=401wt.eu-S933051AbXIAXGD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933051AbXIAXGD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 19:06:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755745AbXIAXFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 19:05:52 -0400
Received: from barikada.upol.cz ([158.194.242.200]:45633 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755714AbXIAXFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 19:05:52 -0400
To: Al Viro <viro@ftp.linux.org.uk>
Cc: david@lang.hm, Alan <alan@clueserver.org>,
       Kyle Moffett <mrmacman_g4@mac.com>, Marc Perkel <mperkel@yahoo.com>,
       Valdis.Kletnieks@vt.edu, Michael Tharp <gxti@partiallystapled.com>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Re: Thinking outside the box on file systems
In-Reply-To: <20070819025758.GR21089@ftp.linux.org.uk>
References: <763705.7247.qm@web52512.mail.re2.yahoo.com> <A631EFDE-354D-498E-980E-2B785517AC51@mac.com> <1187479581.1608.1.camel@zowie.fnordora.org> <Pine.LNX.4.64.0708181902460.22470@asgard.lang.hm> <20070819025758.GR21089@ftp.linux.org.uk>
Date: Sun, 2 Sep 2007 01:20:49 +0200
Message-Id: <E1IRcGn-0005iv-Cj@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Date: Sun, 19 Aug 2007 03:57:58 +0100

>> don't forget the ACPI interpreter.
>
> YAProof that bogons follow Boze statistics...

or bugons, then.

Why big minds didn't do rdev-like binary patching of the kernel image
with binary ACPI data? Getting such data in (any) userspace would be the
only thing in the install process of a modern distro, otherwise it's just
a boring decompressing with copying.
____
