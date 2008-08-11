Return-Path: <linux-kernel-owner+w=401wt.eu-S1755096AbYHKXK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096AbYHKXK3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 19:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbYHKXKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 19:10:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56556 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036AbYHKXKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 19:10:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [Bug #11283] MSI patch blamed for T60p not coming out of suspend to ram
Date: Tue, 12 Aug 2008 01:13:18 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Matthew Wilcox" <matthew@wil.cx>,
       "Matthew Wilcox" <willy@linux.intel.com>,
       "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
References: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik> <cX_-nNkxKaF.A._1H.lCjnIB@albercik> <200808111515.40782.jbarnes@virtuousgeek.org>
In-Reply-To: <200808111515.40782.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808120113.19072.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 12 of August 2008, Jesse Barnes wrote:
> On Saturday, August 9, 2008 3:43 pm Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.26.  Please verify if it still should be listed and let me know
> > (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11283
> > Subject		: MSI patch blamed for T60p not coming out of suspend to ram
> > Submitter	: Michael S. Tsirkin <m.s.tsirkin@gmail.com>
> > Date		: 2008-08-07 16:07 (3 days old)
> 
> The fix for this should be in Linus' tree now.

Thanks, closed.

Rafael
