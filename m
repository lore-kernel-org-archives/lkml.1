Return-Path: <linux-kernel-owner+w=401wt.eu-S1755249AbYIGJEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbYIGJEs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 05:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbYIGJEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 05:04:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39571 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbYIGJEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 05:04:39 -0400
Subject: Re: [Bug #11209] 2.6.27-rc1 process time accounting
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Lukas Hejtmanek <xhejtman@ics.muni.cz>
In-Reply-To: <Wz8EH5sroeE.A.mUD.WswwIB@albercik>
References: <s3QDdfEDq6.A.wlH.MowwIB@albercik>
	 <Wz8EH5sroeE.A.mUD.WswwIB@albercik>
Content-Type: text/plain
Date: Sun, 07 Sep 2008 11:04:33 +0200
Message-Id: <1220778273.8687.20.camel@twins.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.91 (2.23.91-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-09-06 at 23:30 +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11209
> Subject		: 2.6.27-rc1 process time accounting
> Submitter	: Lukas Hejtmanek <xhejtman@ics.muni.cz>
> Date		: 2008-07-31 10:43 (38 days old)
> References	: http://marc.info/?l=linux-kernel&m=121750102917490&w=4
> Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>

Should be fixed in the latest -git

