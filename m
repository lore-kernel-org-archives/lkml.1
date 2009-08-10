Return-Path: <linux-kernel-owner+w=401wt.eu-S1755009AbZHJOHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009AbZHJOHB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 10:07:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754926AbZHJOHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 10:07:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48082 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754629AbZHJOG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 10:06:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Gene Heskett <gene.heskett@verizon.net>
Subject: Re: [Bug #13899] Oops from tar, 2.6.31-rc5, 32 bit on quad core phenom.
Date: Mon, 10 Aug 2009 16:07:55 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <AuPdDySr74O.A.5LC.Pj1fKB@chimera> <u1L1PAbl8zG.A.1SD.pj1fKB@chimera> <200908092342.43656.gene.heskett@verizon.net>
In-Reply-To: <200908092342.43656.gene.heskett@verizon.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200908101607.55673.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 August 2009, Gene Heskett wrote:
> On Sunday 09 August 2009, Rafael J. Wysocki wrote:
> >This message has been generated automatically as a part of a report
> >of recent regressions.
> >
> >The following bug entry is on the current list of known regressions
> >from 2.6.30.  Please verify if it still should be listed and let me know
> >(either way).
> >
> >
> >Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13899
> >Subject		: Oops from tar, 2.6.31-rc5, 32 bit on quad core phenom.
> >Submitter	: Gene Heskett <gene.heskett@verizon.net>
> >Date		: 2009-08-01 13:04 (9 days old)
> >References	: http://marc.info/?l=linux-kernel&m=124913190304149&w=4
> 
> Yes, it is still doing it to rc5 but only on the first invocation after the 
> bootup.  Strangely, it apparently has no other effect, either on the machine, 
> or how amanda itself works.

Thanks for the update.

Rafael
