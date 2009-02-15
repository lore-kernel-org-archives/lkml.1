Return-Path: <linux-kernel-owner+w=401wt.eu-S1754027AbZBOOlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbZBOOlT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 09:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbZBOOlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 09:41:06 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46895 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbZBOOlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 09:41:04 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Alexander E. Patrakov" <patrakov@gmail.com>
Subject: Re: [Bug #12406] 2.6.28 thinks that my PS/2 mouse is a touchpad
Date: Sun, 15 Feb 2009 15:40:52 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Arjan Opmeer" <arjan@opmeer.net>,
       "Denys Vlasenko" <vda.linux@googlemail.com>,
       "Dmitry Torokhov" <dmitry.torokhov@gmail.com>, stable@kernel.org
References: <sTyoMUwdm9B.A.QCH.U40lJB@chimera> <ROx6X68CGJG.A.Ql.E50lJB@chimera> <20090215111446.789c1f8a@home.aephome.ru>
In-Reply-To: <20090215111446.789c1f8a@home.aephome.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902151540.53004.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 February 2009, Alexander E. Patrakov wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.27 and 2.6.28.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.27 and 2.6.28.  Please verify if it still
> > should be listed and let me know (either way).
> 
> Yes, it is still a regression with a patch that is not in -stable.

I think it hasn't been merged yet.
 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12406
> > Subject		: 2.6.28 thinks that my PS/2 mouse is a
> > touchpad Submitter	: Alexander E. Patrakov <patrakov@gmail.com>
> > Date		: 2008-12-27 9:06 (50 days old)
> > References	:
> > http://marc.info/?l=linux-kernel&m=123036893817280&w=4
> > Handled-By	: Arjan Opmeer <arjan@opmeer.net>
> > Patch		:
> > http://marc.info/?l=linux-kernel&m=123092147703236&w=4
