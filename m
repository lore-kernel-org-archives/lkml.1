Return-Path: <linux-kernel-owner+w=401wt.eu-S1757735AbZBEBQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757735AbZBEBQs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 20:16:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753873AbZBEBQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 20:16:35 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49205 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753136AbZBEBQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 20:16:34 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Smith <dsmith@redhat.com>
Subject: Re: [Bug #12602] CRED changes causing setuid failures
Date: Thu, 5 Feb 2009 02:15:47 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera> <pWZw1SZjMCH.A.lpE.3uYiJB@chimera> <4989D9C3.7060408@redhat.com>
In-Reply-To: <4989D9C3.7060408@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902050215.48727.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 February 2009, David Smith wrote:
> Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.28.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12602
> > Subject		: CRED changes causing setuid failures
> > Submitter	: David Smith <dsmith@redhat.com>
> > Date		: 2009-01-29 21:35 (7 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d84f4f992cbd76e8f39c488cf0c5d123843923b1
> > References	: http://marc.info/?l=linux-kernel&m=123326501813668&w=4
> 
> I've verified this still exists in 2.6.29-rc3.
> 
> (git describe says I'm at v2.6.29-rc3-495-gdcf6a79)

Thanks for the update.

Rafael
