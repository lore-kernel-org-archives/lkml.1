Return-Path: <linux-kernel-owner+w=401wt.eu-S1754770AbYKBWHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbYKBWHj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 17:07:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754367AbYKBWHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 17:07:31 -0500
Received: from ox1.aei.mpg.de ([194.94.224.6]:46844 "EHLO ox1.aei.mpg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754339AbYKBWHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 17:07:30 -0500
Date: Sun, 2 Nov 2008 23:07:58 +0100
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Tomas Winkler <tomasw@gmail.com>
Subject: Re: [Bug #11845] Suspend regression on Lenovo x60
Message-ID: <20081102220758.GA14374@localhost.aei.mpg.de>
References: <603i_OdVYPF.A.7_D.mjeDJB@chimera> <wOAXuecskPD.A.3LH.0keDJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <wOAXuecskPD.A.3LH.0keDJB@chimera>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun  2.Nov'08 at 17:07:01 +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.27.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11845
> Subject		: Suspend regression on Lenovo x60
> Submitter	: Jens Axboe <jens.axboe@oracle.com>
> Date		: 2008-10-24 18:02 (10 days old)
> References	: http://marc.info/?l=linux-next&m=122487159829507&w=4
> 		  http://marc.info/?l=linux-kernel&m=122512449714310&w=4
> Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>
> 		  Tomas Winkler <tomasw@gmail.com>
> Patch		: http://marc.info/?l=linux-kernel&m=122513311900482&w=4
> 		  http://marc.info/?l=linux-wireless&m=122518625308673&w=4

It is fixed by commit 10d0bd56966571d0324dfd9bbb8aa913a60bef5f which
is now in Linus' tree.

