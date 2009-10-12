Return-Path: <linux-kernel-owner+w=401wt.eu-S1758333AbZJLV2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758333AbZJLV2Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 17:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758080AbZJLV2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 17:28:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36182 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757920AbZJLV2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 17:28:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frans Pop <elendil@planet.nl>
Subject: Re: [Bug #14141] order 2 page allocation failures in iwlagn
Date: Mon, 12 Oct 2009 23:29:17 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc3-rjw; KDE/4.3.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "David Rientjes" <rientjes@google.com>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Reinette Chatre" <reinette.chatre@intel.com>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera> <L6tb-VyKHZK.A.d4D.P0l0KB@chimera> <200910120157.04616.elendil@planet.nl>
In-Reply-To: <200910120157.04616.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200910122329.17322.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 October 2009, Frans Pop wrote:
> On Monday 12 October 2009, you wrote:
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.30 and 2.6.31.  Please verify if it still should
> > be listed and let me know (either way).
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14141
> > Subject	: order 2 page allocation failures in iwlagn
> > Submitter	: Frans Pop <elendil@planet.nl>
> > Date		: 2009-09-06 7:40 (36 days old)
> > References	: http://marc.info/?l=linux-kernel&m=125222287419691&w=4
> > 		  http://lkml.org/lkml/2009/10/2/86
> > 		  http://lkml.org/lkml/2009/10/5/24
> > Handled-By	: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> See: http://lkml.indiana.edu/hypermail/linux/kernel/0910.1/01395.html
> 
> I don't see that message on lkml yet :-(

I've added the link to the bug entry, thanks for the update.

Rafael
