Return-Path: <linux-kernel-owner+w=401wt.eu-S1754421AbZFFOXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbZFFOXm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 10:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbZFFOXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 10:23:36 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39909 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752992AbZFFOXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 10:23:35 -0400
Subject: Re: [Bug #13378] kernel/async.c broke pata_legacy.c
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       IDE <linux-ide@vger.kernel.org>, Mikael Pettersson <mikpe@it.uu.se>,
       Tejun Heo <tj@kernel.org>
In-Reply-To: <LEcEO2518_I.A.8UD.tIbIKB@chimera>
References: <4to6E2myxvG.A.muC.aIbIKB@chimera>
	 <LEcEO2518_I.A.8UD.tIbIKB@chimera>
Content-Type: text/plain
Date: Sat, 06 Jun 2009 14:23:15 +0000
Message-Id: <1244298195.14676.6.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-05-30 at 21:37 +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.29.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13378
> Subject		: kernel/async.c broke pata_legacy.c
> Submitter	: Mikael Pettersson <mikpe@it.uu.se>
> Date		: 2009-05-24 16:13 (7 days old)
> References	: http://marc.info/?l=linux-kernel&m=124318186507210&w=4
> Handled-By	: James Bottomley <James.Bottomley@hansenpartnership.com>
> Patch		: http://patchwork.kernel.org/patch/25699/

Should now be fixed by upstream commit
45bc955bb1324a46c9539550cc615994e6d0a43d

James


