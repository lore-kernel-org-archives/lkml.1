Return-Path: <linux-kernel-owner+w=401wt.eu-S1753234AbZFENG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbZFENG0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 09:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751419AbZFENGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 09:06:18 -0400
Received: from aun.it.uu.se ([130.238.12.36]:46270 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbZFENGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 09:06:17 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18985.4718.192222.884806@pilspetsen.it.uu.se>
Date: Fri, 5 Jun 2009 14:41:18 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "IDE" <linux-ide@vger.kernel.org>,
       "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       "Mikael Pettersson" <mikpe@it.uu.se>, "Tejun Heo" <tj@kernel.org>
Subject: Re: [Bug #13378] kernel/async.c broke pata_legacy.c
In-Reply-To: <LEcEO2518_I.A.8UD.tIbIKB@chimera>
References: <4to6E2myxvG.A.muC.aIbIKB@chimera>
	<LEcEO2518_I.A.8UD.tIbIKB@chimera>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.29.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D13378
> Subject		: kernel/async.c broke pata_legacy.c
> Submitter	: Mikael Pettersson <mikpe@it.uu.se>
> Date		: 2009-05-24 16:13 (7 days old)
> References	: http://marc.info/?l=3Dlinux-kernel&m=3D124318186507210&w=3D4
> Handled-By	: James Bottomley <James.Bottomley@hansenpartnership.com>
> Patch		: http://patchwork.kernel.org/patch/25699/

paga_legacy remains broken in 2.6.30-rc8, and I still have to
apply the above-mentioned patch to make the affected machine boot.

/Mikael
