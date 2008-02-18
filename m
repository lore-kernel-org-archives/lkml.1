Return-Path: <linux-kernel-owner+w=401wt.eu-S1759530AbYBRQIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759530AbYBRQIX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 11:08:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758898AbYBRQIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 11:08:05 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43140 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757915AbYBRQID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 11:08:03 -0500
Date: Mon, 18 Feb 2008 13:07:45 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: first tree
Message-ID: <20080218130745.4e51624a@gaivota>
In-Reply-To: <20080215092414.097bfb15.sfr@canb.auug.org.au>
References: <20080215003537.8911ce35.sfr@canb.auug.org.au>
	<20080214153850.486f8205@gaivota>
	<20080215092414.097bfb15.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.7; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2008 09:24:14 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Mauro,
> 
> On Thu, 14 Feb 2008 15:38:50 -0200 Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> >
> > Please add v4l-dvb tree, at:
> > 
> > ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-next.git
> > 
> > The above tree has two branches: 'master' and 'stable'
> > 
> > Both branches will have V4L/DVB next patches. The first is against your master,
> > and the second, against your stable.
> > 
> > I've opted to have both trees, since probably 'stable' is the better option for
> > you to clone. On the other hand, 'master' allow me to foresee if an "alien"
> > patch would conflict with a subsystem patch.
> 
> OK, this looks good (I should read ahead in my email before
> replying :-)).  I will fetch the stable branch of this tree instead of
> the previous tree you sent me, OK?

OK.

Cheers,
Mauro
