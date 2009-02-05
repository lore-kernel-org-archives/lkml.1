Return-Path: <linux-kernel-owner+w=401wt.eu-S932271AbZBEB1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271AbZBEB1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 20:27:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757274AbZBEB1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 20:27:37 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49331 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753664AbZBEB1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 20:27:36 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [Bug #12616] boot hang: async vs. kexec
Date: Thu, 5 Feb 2009 02:26:56 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera> <pWZw1SZjMCH.A.xUD.kuYiJB@chimera> <4989C74A.2020402@oracle.com>
In-Reply-To: <4989C74A.2020402@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902050226.57234.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 February 2009, Randy Dunlap wrote:
> Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.28.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12616
> > Subject		: boot hang: async vs. kexec
> > Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
> > Date		: 2009-01-29 13:15 (7 days old)
> > References	: http://lkml.org/lkml/2009/1/29/359
> 
> Please reject this for now.  I'll keep debugging/working on it
> and see if any fixes are needed.

Done.

Thanks,
Rafael
