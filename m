Return-Path: <linux-kernel-owner+w=401wt.eu-S1753987Ab0AKTtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab0AKTtb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 14:49:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751060Ab0AKTtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 14:49:31 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34890 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702Ab0AKTta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 14:49:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: [Bug #14894] pohmelfs: NULL pointer dereference
Date: Mon, 11 Jan 2010 20:50:07 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc3-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>
References: <nzLqtSp97aP.A.RGB.hglSLB@chimera> <CXIfLt-ygXM.A.RRC.4glSLB@chimera> <20100110232306.GA16962@ioremap.net>
In-Reply-To: <20100110232306.GA16962@ioremap.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001112050.07420.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 January 2010, Evgeniy Polyakov wrote:
> On Sun, Jan 10, 2010 at 11:56:17PM +0100, Rafael J. Wysocki (rjw@sisk.pl) wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.31 and 2.6.32.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14894
> > Subject		: pohmelfs: NULL pointer dereference
> > Submitter	: Alexander Beregalov <a.beregalov@gmail.com>
> > Date		: 2009-12-02 1:11 (40 days old)
> > References	: http://marc.info/?l=linux-kernel&m=125971633107940&w=4
> > Handled-By	: Evgeniy Polyakov <zbr@ioremap.net>
> 
> There is a patch to fix the problem, I will test it in a day and push it
> upstrem if it is ok.

Great, thanks a lot!

Rafael
