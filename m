Return-Path: <linux-kernel-owner+w=401wt.eu-S1758795AbZD1VyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758795AbZD1VyU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 17:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756480AbZD1VyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 17:54:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33734 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755290AbZD1Vx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 17:53:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [Bug #13003] [2.6.29 regression] ivtv driver causes strange oops'es, disrupts software suspend
Date: Tue, 28 Apr 2009 23:53:57 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc3-rjw; KDE/4.2.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Artem S. Tashkinov" <t.artem@mailcity.com>
References: <tur5OtdUm3E.A.r2B.7oE9JB@chimera> <egHshlwQQFE.A.C_C.ipE9JB@chimera> <200904270846.28726.hverkuil@xs4all.nl>
In-Reply-To: <200904270846.28726.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904282353.58146.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 April 2009, Hans Verkuil wrote:
> On Sunday 26 April 2009 11:46:28 Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.28 and 2.6.29.
> >
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.28 and 2.6.29.  Please verify if it still should
> > be listed and let me know (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13003
> > Subject		: [2.6.29 regression] ivtv driver causes strange oops'es,
> > disrupts software suspend Submitter	: Artem S. Tashkinov
> > <t.artem@mailcity.com>
> > Date		: 2009-04-03 14:57 (24 days old)
> > Handled-By	: Hans Verkuil <hverkuil@xs4all.nl>
> 
> This isn't a 2.6.29 regression. It is a bug - somewhere - but it's also been 
> reproduced under 2.6.28 so it doesn't qualify as a regression.

Thanks, dropped from the list.

Best,
Rafael
