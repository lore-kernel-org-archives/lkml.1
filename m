Return-Path: <linux-kernel-owner+w=401wt.eu-S1754729AbYHQMcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbYHQMcf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 08:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752991AbYHQMcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 08:32:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39825 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752715AbYHQMcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 08:32:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: [Bug #11346] kernel BUG at arch/x86/mm/pat.c:233!
Date: Sun, 17 Aug 2008 14:35:56 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andi Kleen" <andi@firstfloor.org>
References: <DLWXHEp37wB.A.duD.yZzpIB@albercik> <sNRO-BDDjQL.A.99D.9ZzpIB@albercik> <20080816224526.43145f77@hyperion.delvare>
In-Reply-To: <20080816224526.43145f77@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808171435.57225.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 16 of August 2008, Jean Delvare wrote:
> Hi Rafael,
> 
> On Sat, 16 Aug 2008 21:02:56 +0200 (CEST), Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.26.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11346
> > Subject	: kernel BUG at arch/x86/mm/pat.c:233!
> > Submitter	: Jean Delvare <khali@linux-fr.org>
> > Date		: 2008-08-15 02:10 (2 days old)
> > Handled-By	: Andi Kleen <andi@firstfloor.org>
> > Patch		: http://bugzilla.kernel.org/attachment.cgi?id=17270&action=view
> 
> Andi's patch still needs to be pushed to Linus.

Thanks for the update.

Rafael
