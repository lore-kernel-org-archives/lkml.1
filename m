Return-Path: <linux-kernel-owner+w=401wt.eu-S1751020AbZDQECT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751020AbZDQECT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 00:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750760AbZDQECG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 00:02:06 -0400
Received: from mail.gmx.net ([213.165.64.20]:45012 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750752AbZDQECE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 00:02:04 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19Oeh5qLHdOZk2DVMEe9iF1E8YdNLMwQSVDuBfkmJ
	bypPZzE566x1Ua
Subject: Re: [Bug #13114] USB storage (usbstick) automount woes
From: Mike Galbraith <efault@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <nY3-4PrO6XH.A.wsH.Nw85JB@chimera>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera>
	 <nY3-4PrO6XH.A.wsH.Nw85JB@chimera>
Content-Type: text/plain
Date: Fri, 17 Apr 2009 06:01:59 +0200
Message-Id: <1239940919.5879.11.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-16 at 23:45 +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.29.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13114
> Subject		: USB storage (usbstick) automount woes
> Submitter	: Mike Galbraith <efault@gmx.de>
> Date		: 2009-04-09 9:26 (8 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e6e244b6cb1f70e7109381626293cd40a8334ed3
> References	: http://marc.info/?l=linux-kernel&m=123926928907568&w=4
> Handled-By	: Alan Stern <stern@rowland.harvard.edu>

The fix is in the pipe.

	-Mike

