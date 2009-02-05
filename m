Return-Path: <linux-kernel-owner+w=401wt.eu-S1761633AbZBEBfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761633AbZBEBfa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 20:35:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756659AbZBEBfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 20:35:15 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49412 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755954AbZBEBfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 20:35:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [Bug #12426] TMDC Joystick no longer works in kernel 2.6.28
Date: Thu, 5 Feb 2009 02:34:55 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andrew S. Johnson" <andy@asjohnson.com>
References: <a47yn9c9JrF.A.hz.L5YiJB@chimera> <CGyEB0S4BpO.A.BkB.g5YiJB@chimera> <alpine.LRH.1.10.0902041453190.22097@twin.jikos.cz>
In-Reply-To: <alpine.LRH.1.10.0902041453190.22097@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902050234.56056.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 February 2009, Jiri Kosina wrote:
> On Wed, 4 Feb 2009, Rafael J. Wysocki wrote:
> 
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.27 and 2.6.28.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.27 and 2.6.28.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12426
> > Subject		: TMDC Joystick no longer works in kernel 2.6.28
> > Submitter	: Andrew S. Johnson <andy@asjohnson.com>
> > Date		: 2009-01-10 21:53 (26 days old)
> > References	: http://marc.info/?l=linux-kernel&m=123162486415366&w=4
> 
> I asked [1] the Submitter some time ago to check whether reverting a 
> particular commit fixes the issue, but never heard back.
> 
> [1] http://lkml.org/lkml/2009/1/26/70

Rejected as "insufficient data" and closed.

Thanks,
Rafael
