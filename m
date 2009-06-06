Return-Path: <linux-kernel-owner+w=401wt.eu-S1754961AbZFFWdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961AbZFFWdm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 18:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbZFFWde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 18:33:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57015 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671AbZFFWdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 18:33:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [Bug #13378] kernel/async.c broke pata_legacy.c
Date: Sun, 7 Jun 2009 00:34:03 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc8-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       IDE <linux-ide@vger.kernel.org>, Mikael Pettersson <mikpe@it.uu.se>,
       Tejun Heo <tj@kernel.org>
References: <4to6E2myxvG.A.muC.aIbIKB@chimera> <LEcEO2518_I.A.8UD.tIbIKB@chimera> <1244298195.14676.6.camel@mulgrave.site>
In-Reply-To: <1244298195.14676.6.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906070034.04439.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 06 June 2009, James Bottomley wrote:
> On Sat, 2009-05-30 at 21:37 +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.29.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13378
> > Subject		: kernel/async.c broke pata_legacy.c
> > Submitter	: Mikael Pettersson <mikpe@it.uu.se>
> > Date		: 2009-05-24 16:13 (7 days old)
> > References	: http://marc.info/?l=linux-kernel&m=124318186507210&w=4
> > Handled-By	: James Bottomley <James.Bottomley@hansenpartnership.com>
> > Patch		: http://patchwork.kernel.org/patch/25699/
> 
> Should now be fixed by upstream commit
> 45bc955bb1324a46c9539550cc615994e6d0a43d

Thanks, I've closed the bug.

Best,
Rafael
