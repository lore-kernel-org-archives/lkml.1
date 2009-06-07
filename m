Return-Path: <linux-kernel-owner+w=401wt.eu-S1756032AbZFGQES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbZFGQES (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 12:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753935AbZFGQEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 12:04:07 -0400
Received: from mail.gmx.net ([213.165.64.20]:48012 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753082AbZFGQEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 12:04:06 -0400
X-Authenticated: #33280810
X-Provags-ID: V01U2FsdGVkX1/NnNcngm7NoITnoDUQfEKUEhPe2Hpf84YmAIuw3h
	ClbYanndZzcdEt
Subject: Re: [Bug #13391] Kernel boot hangs at about every second start
 when kms is activated
From: Martin Bammer <mrb74@gmx.at>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eric Anholt <eric@anholt.net>
In-Reply-To: <D9VoutSOyXP.A.E-G.TZ7KKB@chimera>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>
	 <D9VoutSOyXP.A.E-G.TZ7KKB@chimera>
Content-Type: text/plain
Date: Sun, 07 Jun 2009 18:04:01 +0200
Message-Id: <1244390641.4219.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since i disabled most of the debug options this problem has gone. IMHO
this issue has been caused by kdbg.

Am Sonntag, den 07.06.2009, 11:52 +0200 schrieb Rafael J. Wysocki:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.29.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13391
> Subject		: Kernel boot hangs at about every second start when kms is activated
> Submitter	: Martin Bammer <mrb74@gmx.at>
> Date		: 2009-05-26 21:47 (13 days old)
> 
> 

