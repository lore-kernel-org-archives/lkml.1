Return-Path: <linux-kernel-owner+w=401wt.eu-S1754003Ab0AKTl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab0AKTl6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 14:41:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751186Ab0AKTl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 14:41:57 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34847 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753875Ab0AKTl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 14:41:56 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: [Bug #14487] PANIC: early exception 08 rip 246:10 error ffffffff810251b5 cr2 0
Date: Mon, 11 Jan 2010 20:42:27 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc3-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <nzLqtSp97aP.A.RGB.hglSLB@chimera> <CXIfLt-ygXM.A.O1D.qilSLB@chimera> <4B4B2E22.6030903@gmail.com>
In-Reply-To: <4B4B2E22.6030903@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201001112042.27378.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 January 2010, Justin P. Mattock wrote:
> On 01/10/10 14:56, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.31 and 2.6.32.
> >
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> > be listed and let me know (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14487
> > Subject		: PANIC: early exception 08 rip 246:10 error ffffffff810251b5 cr2 0
> > Submitter	: Justin P. Mattock<justinmattock@gmail.com>
> > Date		: 2009-10-23 16:45 (80 days old)
> > References	: http://lkml.org/lkml/2009/10/23/252
> >
> >
> >
> 
> I've played around with this. and
> and much confused at what needs to happen.
> (please feedback on what might be happening);
> In any case I can have another try at finding a fix
> so please leave open.

I will, thanks for the update.

Rafael
