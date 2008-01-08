Return-Path: <linux-kernel-owner+w=401wt.eu-S1754173AbYAHXab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173AbYAHXab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 18:30:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbYAHXaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 18:30:23 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:2248 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbYAHXaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 18:30:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=XKDwz/oYEnadXx/aCDnovCVkE9Y90sPilhYvXUZ4fqf14E3CimpCZilD7UENC6WrCQO8D1oIFJ40yJLEFOwvokQmr5S9Jr+cAp9G+7HX9qUDXHwa8XauSueOcBkALTVzwXjp5i3tjZtzrNerGRUPZv/02LCLq1k2hL+iwgTSXaY=
Date: Wed, 9 Jan 2008 00:30:32 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] x86: coding style fixes in arch/x86/pci/
Message-ID: <20080109003032.78cfeedd@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,
after you asked me to work against x86.git[1] I noticed
that 4 out of 5 of my previous patches didn't make sense any longer.

While I was compiling the kernel, and hopefully starting doing something
more useful (Sam, again thank you for the hints), 
I create these 4 very simple patches fixing some coding style issue.

[PATCH 1/4] x86: coding style fixes in /arch/x86/pci/common.c
[PATCH 2/4] x86: coding style fixes in arch/x86/pci/acpi.c
[PATCH 3/4] x86: coding style fixes in arch/x86/pci/direct.c
[PATCH 4/4] x86: coding style fixes in arch/x86/pci/fixup.c

And here is the diffstat:
 arch/x86/pci/acpi.c   |    4 ++--
 arch/x86/pci/common.c |   12 +++++-------
 arch/x86/pci/direct.c |   10 +++++-----
 arch/x86/pci/fixup.c  |   30 +++++++++++++++---------------
 4 files changed, 27 insertions(+), 29 deletions(-)


[1] git-pull git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git mm
