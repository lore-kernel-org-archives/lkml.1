Return-Path: <linux-kernel-owner+w=401wt.eu-S1758564AbZIFVct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758564AbZIFVct (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 17:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758424AbZIFVcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 17:32:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49249 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694AbZIFVcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 17:32:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Rientjes <rientjes@google.com>
Subject: Re: [Bug #13780] NULL pointer dereference loading powernowk8
Date: Sun, 6 Sep 2009 23:33:43 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rc9-rjw; KDE/4.3.1; x86_64; ; )
Cc: Kurt Roeckx <kurt@roeckx.be>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <aIL9jMAYJnG.A.WjH.M3BpKB@chimera> <hKF51Pczj6N.A.Y9H.r3BpKB@chimera> <alpine.DEB.1.00.0909061426500.16301@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.1.00.0909061426500.16301@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909062333.43679.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 06 September 2009, David Rientjes wrote:
> On Sun, 6 Sep 2009, Rafael J. Wysocki wrote:
> 
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.29 and 2.6.30.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13780
> > Subject		: NULL pointer dereference loading powernowk8
> > Submitter	: Kurt Roeckx <kurt@roeckx.be>
> > Date		: 2009-07-15 18:00 (54 days old)
> > 
> 
> This bug has been abandoned as far as I know since there has been no 
> response from the reporter in three weeks to post the latest failure 
> (which was then 2.6.31-rc5).

OK, I'm going to close it as "not enough information", then.

Thanks,
Rafael
