Return-Path: <linux-kernel-owner+w=401wt.eu-S1752139AbYJ0TnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139AbYJ0TnL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 15:43:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059AbYJ0Tmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 15:42:55 -0400
Received: from ox1.aei.mpg.de ([194.94.224.6]:59044 "EHLO ox1.aei.mpg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbYJ0Tmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 15:42:54 -0400
Date: Mon, 27 Oct 2008 20:43:28 +0100
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: Re: [Bug #11851] wmifinfo dockapp takes 100% of cpu
Message-ID: <20081027194328.GA4353@localhost.aei.mpg.de>
References: <nw2Y6lk-0lG.A.VUB.RV5AJB@chimera> <t1C3RWL0r7M.A.ltB.aV5AJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <t1C3RWL0r7M.A.ltB.aV5AJB@chimera>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 25.Oct'08 at 22:06:49 +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.27.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11851
> Subject		: wmifinfo dockapp takes 100% of cpu
> Submitter	: Carlos R. Mafra <crmafra2@gmail.com>
> Date		: 2008-10-25 9:40 (1 days old)
> References	: http://marc.info/?l=linux-kernel&m=122492763030453&w=4
> Handled-By	: Arjan van de Ven <arjan@linux.intel.com>
> 		  Marcin Slusarz <marcin.slusarz@gmail.com>
> Patch		: http://marc.info/?l=linux-kernel&m=122496409612709&w=4


Fixed by commit 4d36a9e65d4966b433b2f3424d9457468bc80e00 
