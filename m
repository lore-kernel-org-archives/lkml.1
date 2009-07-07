Return-Path: <linux-kernel-owner+w=401wt.eu-S1755289AbZGGLEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbZGGLEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 07:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755095AbZGGLEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 07:04:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:32792 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754823AbZGGLEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 07:04:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jarek Poplawski <jarkao2@gmail.com>
Subject: Re: [Bug #13647] fb/mmap lockdep report.
Date: Tue, 7 Jul 2009 13:04:53 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc2-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrea Righi <righi.andrea@gmail.com>, Dave Jones <davej@redhat.com>
References: <tSdKBEwEOhE.A.2wF.s_oUKB@chimera> <bXZeuxPQAWE.A.usG.AApUKB@chimera> <20090707055758.GA3071@ami.dom.local>
In-Reply-To: <20090707055758.GA3071@ami.dom.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907071304.53782.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 July 2009, Jarek Poplawski wrote:
> On Tue, Jul 07, 2009 at 02:00:51AM +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.29 and 2.6.30.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13647
> > Subject		: fb/mmap lockdep report.
> > Submitter	: Dave Jones <davej@redhat.com>
> > Date		: 2009-06-21 13:33 (16 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=513adb58685615b0b1d47a3f0d40f5352beff189
> > References	: http://lkml.org/lkml/2009/6/21/90
> > 		  http://lkml.org/lkml/2009/6/21/122
> 
> This lockdep report isn't triggered by 2.6.31-rc2 anymore.

Thanks, I've closed the bug.

Best,
Rafael
