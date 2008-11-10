Return-Path: <linux-kernel-owner+w=401wt.eu-S1755549AbYKJSBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549AbYKJSBw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 13:01:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754651AbYKJSBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 13:01:33 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49496 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754563AbYKJSBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 13:01:32 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: [Bug #11895] 2.6.28-rc2 regression: keyboard dead after reboot on Toshiba Portege 4000
Date: Mon, 10 Nov 2008 19:06:30 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Avi Kivity" <avi@redhat.com>, "Ingo Molnar" <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>
References: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera> <wnN9HICUAgP.A.5I.V5zFJB@chimera> <200811101953.38938.arvidjaar@mail.ru>
In-Reply-To: <200811101953.38938.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811101906.30776.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 10 of November 2008, Andrey Borzenkov wrote:
> On Sunday 09 November 2008, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.27.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> 
> it is fixed in rc4
> 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11895
> 
> Could you reassign this to ACPI product so this bug could be further
> investigated or should I open seperate one?

Since you're saying it's fixed in -rc4, I'll close it and please open a
separate one for the issue that's not been fixed yet.

Thanks,
Rafael
