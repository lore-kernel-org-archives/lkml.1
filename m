Return-Path: <linux-kernel-owner+w=401wt.eu-S1760156AbZBDVo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760156AbZBDVo7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 16:44:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756440AbZBDVou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 16:44:50 -0500
Received: from gate.crashing.org ([63.228.1.57]:43859 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756151AbZBDVot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 16:44:49 -0500
Subject: Re: [Bug #12508] "powerpc/pci: Reserve legacy regions on PCI"
 broke my G3
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Mikael Pettersson <mikpe@it.uu.se>
In-Reply-To: <pWZw1SZjMCH.A.ZIG.YvYiJB@chimera>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
	 <pWZw1SZjMCH.A.ZIG.YvYiJB@chimera>
Content-Type: text/plain
Date: Thu, 05 Feb 2009 08:44:27 +1100
Message-Id: <1233783867.4612.9.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-04 at 11:24 +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).

Can you check if it's still broken ?

59b608c2c33feacc8be281ec3ba9ca2a3a5cb9a7 might have fixed it...

Cheers,
Ben.

> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12508
> Subject		: "powerpc/pci: Reserve legacy regions on PCI" broke my G3
> Submitter	: Mikael Pettersson <mikpe@it.uu.se>
> Date		: 2009-01-17 22:46 (19 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=c1f343028d35ba4e88cd4a3c44e0d8b8a84264ee
> References	: http://marc.info/?l=linux-kernel&m=123223247325452&w=4
> Handled-By	: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> 

