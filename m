Return-Path: <linux-kernel-owner+w=401wt.eu-S1754559AbZCVNwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbZCVNwA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 09:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752967AbZCVNvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 09:51:49 -0400
Received: from aun.it.uu.se ([130.238.12.36]:53490 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224AbZCVNvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 09:51:49 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18886.16987.469495.585049@pilspetsen.it.uu.se>
Date: Sun, 22 Mar 2009 14:51:23 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Francois Romieu" <romieu@fr.zoreil.com>,
       "Mikael Pettersson" <mikpe@it.uu.se>
Subject: Re: [Bug #12867] 2.6.29-rc7 broke r8169 MAC on Thecus n2100 ARM board
In-Reply-To: <l8NZ2a3iQtG.A.rS.mZTxJB@chimera>
References: <GPBuLTara4J.A.3kH.TZTxJB@chimera>
	<l8NZ2a3iQtG.A.rS.mZTxJB@chimera>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D12867
> Subject		: 2.6.29-rc7 broke r8169 MAC on Thecus n2100 ARM board
> Submitter	: Mikael Pettersson <mikpe@it.uu.se>
> Date		: 2009-03-09 20:29 (13 days old)
> References	: http://marc.info/?l=3Dlinux-kernel&m=3D123663065403760&w=3D4
> Handled-By	: Francois Romieu <romieu@fr.zoreil.com>

Fixed in Linus' tree by ea8dbdd17099a9a5864ebd4c87e01e657b19c7ab.
