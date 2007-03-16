Return-Path: <linux-kernel-owner+w=401wt.eu-S1753642AbXCPUDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbXCPUDn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 16:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753645AbXCPUDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 16:03:43 -0400
Received: from wilma.widomaker.com ([204.17.220.5]:4490 "EHLO
	wilma.widomaker.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642AbXCPUDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 16:03:42 -0400
Date: Fri, 16 Mar 2007 16:03:38 -0400
From: Charles Shannon Hendrix <shannon@widomaker.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: SATA problems in 2.6.20.3
Message-ID: <20070316160338.3923edcb@daydream.goid.lan>
In-Reply-To: <45FABE9D.6070600@garzik.org>
References: <20070316113657.161e5315@daydream.goid.lan>
	<45FABE9D.6070600@garzik.org>
Organization: Big Endian
X-Mailer: Claws Mail 2.8.0 (GTK+ 2.8.20; i486-slackware-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Mar 2007 11:58:21 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> Charles Shannon Hendrix wrote:
> > I normally run a modified 2.6.19 kernel and it works great.
> > 
> > I recently tried 2.6.20 and had severe SATA problems with it.
> > 
> > Yesterday I tried 2.6.20.3, and the problems are still there.
> 
> Setting the module parameter 'adma' to zero fixes this, yes?

Seems to.

NCQ would be nice of course, but this is usable.

 
-- 
The strength of the Constitution lies entirely in the determination of
each citizen to defend it.  Only if every single citizen feels duty
bound to do his share in this defense are the constitutional rights
secure. -- Albert Einstein
