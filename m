Return-Path: <linux-kernel-owner+w=401wt.eu-S1756549Ab0AMV5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549Ab0AMV5B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 16:57:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756534Ab0AMV44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 16:56:56 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48963 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756581Ab0AMV4x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 16:56:53 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: =?utf-8?q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [Bug #15041] Pagemap endless read loop with LTP
Date: Wed, 13 Jan 2010 22:57:34 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc3-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera> <omZ8aBZReyD.A.tvF.tMlSLB@chimera> <2375c9f91001121904h2857760akbf2dd2c9f7441fc5@mail.gmail.com>
In-Reply-To: <2375c9f91001121904h2857760akbf2dd2c9f7441fc5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201001132257.34123.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 January 2010, Américo Wang wrote:
> On Mon, Jan 11, 2010 at 6:32 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.32.  Please verify if it still should be listed and let me know
> > (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=15041
> > Subject         : Pagemap endless read loop with LTP
> > Submitter       : Andi Kleen <andi@firstfloor.org>
> > Date            : 2010-01-10 2:09 (1 days old)
> > References      : http://marc.info/?l=linux-kernel&m=126308941423848&w=4
> >
> 
> According to Andi's later reply, it shoud not be an endless loop,
> it just takes a rather long time.

Andi?
