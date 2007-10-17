Return-Path: <linux-kernel-owner+w=401wt.eu-S935551AbXJQARo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935551AbXJQARo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 20:17:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751849AbXJQARd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 20:17:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38142 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbXJQARc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 20:17:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Regression: GRUB from openSUSE 10.2 doesn't boot current -git
Date: Wed, 17 Oct 2007 02:33:19 +0200
User-Agent: KMail/1.9.5
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710170233.20445.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

As stated in the subject, I cannot boot the current -git (most recent commit
821f3eff7cdb9d6c7076effabd46c96c322daed1) using GRUB on x86-64 openSUSE 10.2.

The GRUB says that the kernel image is too big and doesn't fit into memory, but
the kernel has been built and installed in exactly the same way as all of the
previous -git kernels.

Greetings,
Rafael
