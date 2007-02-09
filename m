Return-Path: <linux-kernel-owner+w=401wt.eu-S1946238AbXBIJMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946238AbXBIJMV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 04:12:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946239AbXBIJMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 04:12:21 -0500
Received: from ozlabs.org ([203.10.76.45]:38605 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946238AbXBIJMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 04:12:20 -0500
Subject: [PATCH 0/10] lguest
From: Rusty Russell <rusty@rustcorp.com.au>
To: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       virtualization <virtualization@lists.osdl.org>
Content-Type: text/plain
Date: Fri, 09 Feb 2007 20:11:36 +1100
Message-Id: <1171012296.2718.26.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series is against 2.6.20; some things are in flux, so there
might be issues as other things flow into the latest -git tree.

>From the documentation:

Lguest is designed to be a minimal hypervisor for the Linux kernel, for
Linux developers and users to experiment with virtualization with the
minimum of complexity.  Nonetheless, it should have sufficient
features to make it useful for specific tasks, and, of course, you are
encouraged to fork and enhance it.

Features:

- Kernel module which runs in a normal kernel.
- Simple I/O model for communication.
- Simple program to create new guests.
- Logo contains cute puppies: http://lguest.ozlabs.org

Developer features:

- Fun to hack on.
- No ABI: being tied to a specific kernel anyway, you can change
anything.
- Many opportunities for improvement or feature implementation.

Cheers!
Rusty

