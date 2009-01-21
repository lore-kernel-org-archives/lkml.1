Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbZAUQSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbZAUQSy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 11:18:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751702AbZAUQSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 11:18:43 -0500
Received: from ti-out-0910.google.com ([209.85.142.184]:60400 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbZAUQSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 11:18:42 -0500
Date: Wed, 21 Jan 2009 17:18:28 +0100
From: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [Bug #12409] NULL pointer dereference at get_stats()
Message-ID: <20090121161828.GA2739@gambetta>
References: <KTnguC9mFUC.A.VNB.TJRdJB@chimera> <cX2gZ6Cy9nC.A.N0B.pJRdJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cX2gZ6Cy9nC.A.N0B.pJRdJB@chimera>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 10:45:43PM +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.27 and 2.6.28.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.27 and 2.6.28.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12409
> Subject		: NULL pointer dereference at get_stats()
> Submitter	: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
> Date		: 2008-12-30 12:53 (21 days old)
> References	: http://marc.info/?l=linux-kernel&m=123064167008695&w=4
> Handled-By	: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
> 
> 
Hello Rafael,

Not sure what the status should be for that one, it sure seems vmware
related, and I don't have one handy.

Regards,
Frederik
