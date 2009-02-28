Return-Path: <linux-kernel-owner+w=401wt.eu-S1755670AbZB1Vuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670AbZB1Vuk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 16:50:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752718AbZB1Vuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 16:50:32 -0500
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:52551 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbZB1Vuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 16:50:32 -0500
Date: Sat, 28 Feb 2009 21:50:27 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [Bug #12762] Disk errors loop forever in 2.6.29
Message-ID: <20090228215027.GA22913@silver.sucs.org>
References: <GVhknozYwrL.A.hiC.rozoJB@chimera> <vP9hdyF4fL.A.dKD.3ozoJB@chimera>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <vP9hdyF4fL.A.dKD.3ozoJB@chimera>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 23, 2009 at 10:48:17PM +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12762
> Subject		: Disk errors loop forever in 2.6.29
> Submitter	: Sitsofe Wheeler <sitsofe@yahoo.com>
> Date		: 2009-02-19 13:53 (5 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b60af5b0adf0da24c673598c8d3fb4d4189a15ce
> References	: http://marc.info/?l=linux-kernel&m=123505185407604&w=4
> Handled-By	: James Bottomley <James.Bottomley@hansenpartnership.com>
> Patch		: http://marc.info/?l=linux-kernel&m=123508030726900&w=4

Sorry I wasn't paying enough attention (am I going to get this message
for every rc?). Yes this still happens in 2.6.29-rc6.

-- 
Sitsofe | http://sucs.org/~sits/
