Return-Path: <linux-kernel-owner+w=401wt.eu-S1755839AbZGGJSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839AbZGGJSm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 05:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754794AbZGGJSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 05:18:35 -0400
Received: from aun.it.uu.se ([130.238.12.36]:54037 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753732AbZGGJSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 05:18:34 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19027.4815.420637.375450@pilspetsen.it.uu.se>
Date: Tue, 7 Jul 2009 11:18:07 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Grant Grundler" <grundler@parisc-linux.org>,
       "H. Peter Anvin" <hpa@zytor.com>, "Matthew Wilcox" <matthew@wil.cx>,
       "Mikael Pettersson" <mikpe@it.uu.se>
Subject: Re: [Bug #13673] HIGHMEM64G causes hang in PCI init on 32-bit x86
In-Reply-To: <dWkuWjWDsSB.A.HoE.b0oUKB@chimera>
References: <35kKlbXMqWN.A.RXD.D0oUKB@chimera>
	<dWkuWjWDsSB.A.HoE.b0oUKB@chimera>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D13673
> Subject		: HIGHMEM64G causes hang in PCI init on 32-bit x86
> Submitter	: Mikael Pettersson <mikpe@it.uu.se>
> Date		: 2009-06-26 15:59 (11 days old)
> First-Bad-Commit: http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linu=
> x-2.6.git;a=3Dcommit;h=3D95ee14e4379c5e19c0897c872350570402014742
> References	: http://marc.info/?l=3Dlinux-pci&m=3D124615181602643&w=3D4
> Handled-By	: H. Peter Anvin <hpa@zytor.com>

Fixed in 2.6.31-rc2.
