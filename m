Return-Path: <linux-kernel-owner+w=401wt.eu-S932494AbZHUQoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494AbZHUQoE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 12:44:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932321AbZHUQoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 12:44:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43093 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932313AbZHUQoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 12:44:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Subject: Re: [Bug #13620] acpi_enforce_resources broken - conflicting i2c module loaded on some EeePCs
Date: Fri, 21 Aug 2009 18:44:49 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-rjw; KDE/4.3.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Bob Moore <robert.moore@intel.com>, Lin Ming <ming.m.lin@intel.com>
References: <xDf-7eSwYsC.A.-6B.klIjKB@chimera> <Era7U-todKF.A.wsC.gmIjKB@chimera> <9b2b86520908210235l7961410ag74200291c7f8e3a5@mail.gmail.com>
In-Reply-To: <9b2b86520908210235l7961410ag74200291c7f8e3a5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908211844.49475.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 August 2009, Alan Jenkins wrote:
> On 8/19/09, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.29 and 2.6.30.
> >
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> > be listed and let me know (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13620
> > Subject		: acpi_enforce_resources broken - conflicting i2c module loaded on
> > some EeePCs
> > Submitter	: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> > Date		: 2009-06-25 08:31 (56 days old)
> > References	:
> > <http://lists.alioth.debian.org/pipermail/debian-eeepc-devel/2009-June/002316.html>
> > Handled-By	: Lin Ming <ming.m.lin@intel.com>
> > Patch		: http://patchwork.kernel.org/patch/33626/
> 
> This must have been fixed in -rc6, because someone just complained
> about it working again :-).
> <http://article.gmane.org/gmane.linux.acpi.devel/40999/>
> 
> I confirmed this on my own EeePC; i2c-i801 is now correctly denied
> access to the IO resources claimed by ACPI.  Please remove this
> regression from your list.

Thanks, closed.

Rafael
