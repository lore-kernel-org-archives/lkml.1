Return-Path: <linux-kernel-owner+w=401wt.eu-S1755502Ab0AEVcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab0AEVcb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 16:32:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755353Ab0AEVca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 16:32:30 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34207 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755325Ab0AEVca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 16:32:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andreas Friedrich <andreas.friedrich@ts.fujitsu.com>
Subject: Re: [Bug #14902] Boot ends not on tty1
Date: Tue, 5 Jan 2010 22:32:58 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Wolfgang Erig <Wolfgang.Erig@ts.fujitsu.com>
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera> <srmJ8vMxKPH.A.WjB.MwhOLB@chimera> <20100105085743.GA13491@upset.ux.pdb.fsc.net>
In-Reply-To: <20100105085743.GA13491@upset.ux.pdb.fsc.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001052232.58559.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 January 2010, Andreas Friedrich wrote:
> Hi Rafael,
> 
> On Di, Dez 29, 2009 at 04:28:54 +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.31 and 2.6.32.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> > be listed and let me know (either way).
> 
> the problem was gone after the latest Debian lenny and etch upgrades
> (one of libexpat1, libltdl3, libpq4/5 does the fix). I think that the 
> kernel change which came with e11c675ede0d42a405ae595528bf0b29ce1ae56f
> is now supported in Debian, so it is no longer a kernel issue.
> 
> Please remove the error from the regression list.

Thanks, closing.

Rafael
