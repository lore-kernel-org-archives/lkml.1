Return-Path: <linux-kernel-owner+w=401wt.eu-S1752798AbXJZEDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbXJZEDI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 00:03:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750759AbXJZECz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 00:02:55 -0400
Received: from NEUROSIS.MIT.EDU ([18.95.3.133]:48206 "EHLO neurosis.jim.sh"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737AbXJZECy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 00:02:54 -0400
Date: Fri, 26 Oct 2007 00:02:26 -0400
From: Jim Paris <jim@jtan.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Steen Eugen Poulsen <sep@lix-world.net>,
       Andrew Morton <akpm@linux-foundation.org>, lists@dusted.dk,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       bruce.allen@aei.mpg.de
Subject: Re: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
Message-ID: <20071026040226.GA26960@jim.sh>
References: <56020.194.255.108.253.1192004925.squirrel@root.dusted.dk> <20071012174153.69556b32.akpm@linux-foundation.org> <47105C53.7040603@lix-world.net> <471DC52B.20802@gmail.com> <471F2647.4030304@lix-world.net> <47214593.1080102@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47214593.1080102@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> [please don't drop cc.  restored]
> 
> Steen Eugen Poulsen wrote:
> >Tejun Heo skrev:
> >>All these are caused by smartd.  Updating should fix the problem.
> >
> >Okay, but there is no newer smartd than what I'm using. (5.37)
> 
> Bruce?  Original thread can be read from...
> 
> http://thread.gmane.org/gmane.linux.kernel/588972

The fixes were added in smartmontools CVS, but there hasn't been a
release since then.

-jim
