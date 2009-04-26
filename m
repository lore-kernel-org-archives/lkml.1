Return-Path: <linux-kernel-owner+w=401wt.eu-S1754793AbZDZMTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbZDZMTm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 08:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753450AbZDZMTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 08:19:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43746 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799AbZDZMTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 08:19:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [Bug #13108] 2.6.30-rc1: white screen during boot (regression) on spitz
Date: Sun, 26 Apr 2009 14:18:44 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc3-rjw; KDE/4.2.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Dmitry Eremin-Solenikov" <dbaryshkov@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera> <nY3-4PrO6XH.A.sZ.Ww85JB@chimera> <20090425115455.GA1339@ucw.cz>
In-Reply-To: <20090425115455.GA1339@ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904261418.45085.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 25 April 2009, Pavel Machek wrote:
> On Thu 2009-04-16 23:45:04, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.29.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13108
> > Subject		: 2.6.30-rc1: white screen during boot (regression) on spitz
> > Submitter	: Pavel Machek <pavel@ucw.cz>
> > Date		: 2009-04-10 10:34 (7 days old)
> > References	: http://marc.info/?l=linux-kernel&m=123935954223418&w=4
> > Handled-By	: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> 
> It was fixed in 2.6.30-rc3 as a test boot confirmed... (I have a link
> to patch fixing it, but I guess we can simply close this.) Thanks!

Thanks, closed.

Rafael
