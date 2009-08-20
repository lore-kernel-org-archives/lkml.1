Return-Path: <linux-kernel-owner+w=401wt.eu-S1754599AbZHTOyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbZHTOyW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 10:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754480AbZHTOyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 10:54:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38219 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754262AbZHTOyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 10:54:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: reinette chatre <reinette.chatre@intel.com>
Subject: Re: [Bug #13819] system freeze when switching to console
Date: Thu, 20 Aug 2009 16:55:15 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-rjw; KDE/4.3.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eric Anholt <eric@anholt.net>, "Ma, Ling" <ling.ma@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <jCYznkTxcLB.A.EPH.eNIjKB@chimera> <ADSuNT6McuD.A.cdB.vOIjKB@chimera> <1250724928.30019.14331.camel@rc-desk>
In-Reply-To: <1250724928.30019.14331.camel@rc-desk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <200908201655.15256.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 August 2009, reinette chatre wrote:
> On Wed, 2009-08-19 at 13:26 -0700, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.30.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13819
> > Subject		: system freeze when switching to console
> > Submitter	: Reinette Chatre <reinette.chatre@intel.com>
> > Date		: 2009-07-23 17:57 (28 days old)
> 
> This issue is still present in 2.6.31-rc6. Unfortunately the patches I
> reverted to get a working system does not revert cleanly anymore.

Thanks for the update.

Rafael
