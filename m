Return-Path: <linux-kernel-owner+w=401wt.eu-S1754552AbYJEKx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbYJEKx0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 06:53:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbYJEKxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 06:53:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46948 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589AbYJEKxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 06:53:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Hugh Dickins <hugh@veritas.com>
Subject: Re: [Bug #11696] 2.6.27-rc8 doubled times
Date: Sun, 5 Oct 2008 12:57:11 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <0pOgGB.A.uLG.E475IB@wind> <yWwteD.A.itG.Y475IB@wind> <Pine.LNX.4.64.0810050414260.27517@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0810050414260.27517@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810051257.11835.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 5 of October 2008, Hugh Dickins wrote:
> On Sat, 4 Oct 2008, Rafael J. Wysocki wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11696
> > Subject		: 2.6.27-rc8 doubled times
> > Submitter	: Hugh Dickins <hugh@veritas.com>
> > Date		: 2008-10-03 10:21 (2 days old)
> > References	: http://marc.info/?l=linux-kernel&m=122302939313636&w=4
> > Handled-By	: Thomas Gleixner <tglx@linutronix.de>
> > Patch		: http://marc.info/?l=linux-kernel&m=122307260621434&w=4
> 
> Can now be closed, thanks Rafael: Linus has taken Thomas's
> commit 07454bfff151d2465ada809bbaddf3548cc1097c
> clockevents: check broadcast tick device not the clock events device
> and I've just confirmed that the latest git indeed fixes the issue.

Thanks, closed.

Rafael
