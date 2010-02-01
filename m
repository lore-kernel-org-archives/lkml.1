Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab0BAKst (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 05:48:49 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53780 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385Ab0BAKsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 05:48:47 -0500
Date: Mon, 1 Feb 2010 11:48:46 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #14942] gkrellm no longer shows all the temperatures on
	thinkpad x60
Message-ID: <20100201104846.GB5809@atrey.karlin.mff.cuni.cz>
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera> <omZ8aBZReyD.A.IpH.TNlSLB@chimera> <20100111094027.GB16080@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100111094027.GB16080@khazad-dum.debian.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, 10 Jan 2010, Rafael J. Wysocki wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14942
> > Subject		: gkrellm no longer shows all the temperatures on thinkpad x60
> > Submitter	: Pavel Machek <pavel@ucw.cz>
> > Date		: 2009-12-27 21:57 (15 days old)
> > References	: http://marc.info/?l=linux-kernel&m=126195107005565&w=4
> > Handled-By	: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> > Patch		: http://patchwork.kernel.org/patch/69809/
> 
> Waiting for Pavel to confirm whether this can be closed or not.  There could
> be more than one bug involved, and I only fixed one.

Can be closed; it seems that gkrellm removed the graphs after it
failed once, or something like that.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
