Return-Path: <linux-kernel-owner+w=401wt.eu-S1755930AbYFTLNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930AbYFTLNh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 07:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753401AbYFTLNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 07:13:25 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60923 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbYFTLNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 07:13:24 -0400
X-Greylist: delayed 1430 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Jun 2008 07:13:24 EDT
Date: Fri, 20 Jun 2008 12:49:34 +0200
From: Pavel Machek <pavel@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kevin Winchester <kjwinchester@gmail.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Bisecting tip/auto-x86-next?
Message-ID: <20080620104934.GA22326@atrey.karlin.mff.cuni.cz>
References: <485AFC9B.7090502@gmail.com> <20080620101722.GD17692@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080620101722.GD17692@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> * Kevin Winchester <kjwinchester@gmail.com> wrote:

> > Hi,
> >
> > I am trying to track down a problem I reported here:
> >
> > http://lkml.org/lkml/2008/6/11/431

Can you try iommu=memaper=2 ?

Is it amd64 machine?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
pomozte zachranit klanovicky les:  http://www.ujezdskystrom.info/
