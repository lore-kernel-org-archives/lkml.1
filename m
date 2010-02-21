Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab0BUWa3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 17:30:29 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59259 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753136Ab0BUWa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 17:30:27 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Justin P. mattock" <justinmattock@gmail.com>
Subject: Re: [Bug #14487] PANIC: early exception 08 rip 246:10 error ffffffff810251b5 cr2 0
Date: Sun, 21 Feb 2010 23:31:24 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc8-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
References: <4u4d-2M3yXH.A.XW.XqagLB@chimera> <wj3ZQZlk_KB.A.bPD.FxagLB@chimera> <4B81B2CB.50503@gmail.com>
In-Reply-To: <4B81B2CB.50503@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201002212331.24718.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 21 February 2010, Justin P. mattock wrote:
> On 02/21/2010 01:42 PM, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.31 and 2.6.32.
> >
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14487
> > Subject		: PANIC: early exception 08 rip 246:10 error ffffffff810251b5 cr2 0
> > Submitter	: Justin P. Mattock<justinmattock@gmail.com>
> > Date		: 2009-10-23 16:45 (122 days old)
> > References	: http://lkml.org/lkml/2009/10/23/252
> > Handled-By	: Jan Beulich<jbeulich@novell.com>
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> 
> 
> yeah still here.. worst is I'm able to see this with
> suse11.2 as well as with my custom system.
> 
> so please leave open.

Thanks for the update.

Rafael
