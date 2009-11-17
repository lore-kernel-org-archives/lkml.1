Return-Path: <linux-kernel-owner+w=401wt.eu-S1756370AbZKQW1K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370AbZKQW1K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 17:27:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755738AbZKQW1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 17:27:09 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38585 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753078AbZKQW1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 17:27:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: [Bug #14379] ACPI Warning for _SB_.BAT0._BIF: Converted Buffer to expected String
Date: Tue, 17 Nov 2009 23:28:44 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rc7-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>, Lin Ming <ming.m.lin@intel.com>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera> <xXQGFmujPl.A.UR.8TdALB@chimera> <4B01EC25.5010703@gmail.com>
In-Reply-To: <4B01EC25.5010703@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200911172328.44848.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 November 2009, Justin P. Mattock wrote:
> Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.31.  Please verify if it still should be listed and let me know
> > (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14379
> > Subject		: ACPI Warning for _SB_.BAT0._BIF: Converted Buffer to expected String
> > Submitter	: Justin Mattock<justinmattock@gmail.com>
> > Date		: 2009-10-08 21:46 (40 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d9adc2e031bd22d5d9607a53a8d3b30e0b675f39
> > References	: http://marc.info/?l=linux-kernel&m=125504031328941&w=4
> > Handled-By	: Alexey Starikovskiy<astarikovskiy@suse.de>
> > Patch		: http://bugzilla.kernel.org/attachment.cgi?id=23347
> >
> >
> >
> >    
> o.k. just pulled the latest to see, and
> the warning message is there.
> so yes this bug report should be open
> until this is fixed.

Thanks for the update.

Rafael
