Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467Ab0BBVFk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 16:05:40 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36462 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756192Ab0BBVFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 16:05:38 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [Bug #14942] gkrellm no longer shows all the temperatures on thinkpad x60
Date: Tue, 2 Feb 2010 22:06:16 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera> <20100111094027.GB16080@khazad-dum.debian.net> <20100201104846.GB5809@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20100201104846.GB5809@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002022206.16747.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 February 2010, Pavel Machek wrote:
> > On Sun, 10 Jan 2010, Rafael J. Wysocki wrote:
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14942
> > > Subject		: gkrellm no longer shows all the temperatures on thinkpad x60
> > > Submitter	: Pavel Machek <pavel@ucw.cz>
> > > Date		: 2009-12-27 21:57 (15 days old)
> > > References	: http://marc.info/?l=linux-kernel&m=126195107005565&w=4
> > > Handled-By	: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> > > Patch		: http://patchwork.kernel.org/patch/69809/
> > 
> > Waiting for Pavel to confirm whether this can be closed or not.  There could
> > be more than one bug involved, and I only fixed one.
> 
> Can be closed; it seems that gkrellm removed the graphs after it
> failed once, or something like that.

Thanks, already closed.

Rafael
