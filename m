Return-Path: <linux-kernel-owner+w=401wt.eu-S1762743AbZCCWXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762743AbZCCWXe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 17:23:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761199AbZCCWTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 17:19:44 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39735 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757986AbZCCWTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 17:19:42 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [Bug #12762] Disk errors loop forever in 2.6.29
Date: Tue, 3 Mar 2009 23:15:10 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Sitsofe Wheeler <sitsofe@yahoo.com>
References: <KiHv0irKPzE.A.l3.hUarJB@chimera> <SLCXkuHtxAO.A.MVC.EVarJB@chimera> <1236118049.24019.6.camel@localhost.localdomain>
In-Reply-To: <1236118049.24019.6.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903032315.10999.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 March 2009, James Bottomley wrote:
> On Tue, 2009-03-03 at 20:25 +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.28.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12762
> > Subject		: Disk errors loop forever in 2.6.29
> > Submitter	: Sitsofe Wheeler <sitsofe@yahoo.com>
> > Date		: 2009-02-19 13:53 (13 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b60af5b0adf0da24c673598c8d3fb4d4189a15ce
> > References	: http://marc.info/?l=linux-kernel&m=123505185407604&w=4
> > Handled-By	: James Bottomley <James.Bottomley@hansenpartnership.com>
> > Patch		: http://marc.info/?l=linux-kernel&m=123508030726900&w=4
> 
> In theory, the fix should be upstream here:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=126c098296c8f96cf7f6ca0fdb47265ac7994f00
> 
> (not in a released -rc yet, but should be in -rc7).

Thanks, closed.

Rafael
