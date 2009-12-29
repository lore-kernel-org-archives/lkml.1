Return-Path: <linux-kernel-owner+w=401wt.eu-S1752957AbZL2WRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957AbZL2WRc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 17:17:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbZL2WRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 17:17:31 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40790 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351AbZL2WRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 17:17:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [Bug #14904] slab: possible recursive locking detected
Date: Tue, 29 Dec 2009 23:18:16 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera> <NJVdobuNFNK.A.90H.anhOLB@chimera> <84144f020912290737y695f6e41xe599decf1c68c50e@mail.gmail.com>
In-Reply-To: <84144f020912290737y695f6e41xe599decf1c68c50e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912292318.16384.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 December 2009, Pekka Enberg wrote:
> On Tue, Dec 29, 2009 at 5:09 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.32.  Please verify if it still should be listed and let me know
> > (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14904
> > Subject         : slab: possible recursive locking detected
> > Submitter       : Heiko Carstens <heiko.carstens@de.ibm.com>
> > Date            : 2009-12-18 11:58 (12 days old)
> > References      : http://marc.info/?l=linux-kernel&m=126113754023909&w=4
> > Handled-By      : Pekka Enberg <penberg@cs.helsinki.fi>
> 
> This is the same problem as the following:
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=14951

Thanks, closing as a duplicate.

Rafael
