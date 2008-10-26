Return-Path: <linux-kernel-owner+w=401wt.eu-S1753688AbYJZWPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688AbYJZWPj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 18:15:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbYJZWPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 18:15:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55698 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbYJZWPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 18:15:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [Bug #11669] when CPU hotplugging is disabled, nr_cpu_ids does not get set properly during boot
Date: Sun, 26 Oct 2008 23:20:03 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <3ZqdCuOdOqB.A.EPE.fJ6AJB@chimera> <gLTYxg3cC1.A.BHF.EK6AJB@chimera> <20081026180052.414c7d66@redhat.com>
In-Reply-To: <20081026180052.414c7d66@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810262320.04414.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 26 of October 2008, Chuck Ebbert wrote:
> On Sat, 25 Oct 2008 23:07:50 +0200 (CEST)
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.26 and 2.6.27.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.26 and 2.6.27.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11669
> > Subject		: when CPU hotplugging is disabled, nr_cpu_ids does not get set properly during boot
> > Submitter	: Chuck Ebbert <cebbert@redhat.com>
> > Date		: 2008-09-29 11:40 (27 days old)
> > References	: http://bugzilla.kernel.org/show_bug.cgi?id=11669
> > Handled-By	: Chuck Ebbert <cebbert@redhat.com>
> > Patch		: http://bugzilla.kernel.org/attachment.cgi?id=18105
> > 
> > 
> 
> Fixed by commit 14adf855baefad5ac3b545be23a64e6b61d6b74a

Thanks, closed.

Rafael
