Return-Path: <linux-kernel-owner+w=401wt.eu-S1753338AbZDZIrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbZDZIrj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 04:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751629AbZDZIr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 04:47:29 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52957 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbZDZIr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 04:47:28 -0400
Date: Sat, 25 Apr 2009 13:54:55 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Bug #13108] 2.6.30-rc1: white screen during boot (regression)
	on spitz
Message-ID: <20090425115455.GA1339@ucw.cz>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera> <nY3-4PrO6XH.A.sZ.Ww85JB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <nY3-4PrO6XH.A.sZ.Ww85JB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-04-16 23:45:04, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.29.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13108
> Subject		: 2.6.30-rc1: white screen during boot (regression) on spitz
> Submitter	: Pavel Machek <pavel@ucw.cz>
> Date		: 2009-04-10 10:34 (7 days old)
> References	: http://marc.info/?l=linux-kernel&m=123935954223418&w=4
> Handled-By	: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>

It was fixed in 2.6.30-rc3 as a test boot confirmed... (I have a link
to patch fixing it, but I guess we can simply close this.) Thanks!

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
