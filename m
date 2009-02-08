Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156AbZBHXjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbZBHXjU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 18:39:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbZBHXjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 18:39:11 -0500
Received: from aun.it.uu.se ([130.238.12.36]:40538 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319AbZBHXjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 18:39:10 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18831.27907.957902.357829@harpo.it.uu.se>
Date: Mon, 9 Feb 2009 00:38:43 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       "Mikael Pettersson" <mikpe@it.uu.se>
Subject: Re: [Bug #12508] "powerpc/pci: Reserve legacy regions on PCI" broke my G3
In-Reply-To: <sWhNs83kKPE.A.DvG.Y30jJB@chimera>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera>
	<sWhNs83kKPE.A.DvG.Y30jJB@chimera>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
>This message has been generated automatically as a part of a report
>of recent regressions.
>
>The following bug entry is on the current list of known regressions
>from 2.6.28.  Please verify if it still should be listed and let me know
>(either way).
>
>
>Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D12508
>Subject		: "powerpc/pci: Reserve legacy regions on PCI" broke my G3
>Submitter	: Mikael Pettersson <mikpe@it.uu.se>
>Date		: 2009-01-17 22:46 (23 days old)
>First-Bad-Commit: http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linu=
>x-2.6.git;a=3Dcommit;h=3Dc1f343028d35ba4e88cd4a3c44e0d8b8a84264ee
>References	: http://marc.info/?l=3Dlinux-kernel&m=3D123223247325452&w=3D4
>Handled-By	: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Fixed in 2.6.29-rc4.
See <http://marc.info/?l=linux-kernel&m=123394660404763&w=2> (you were CC:d).
