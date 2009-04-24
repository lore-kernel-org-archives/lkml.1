Return-Path: <linux-kernel-owner+w=401wt.eu-S1758267AbZDXVYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267AbZDXVYU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 17:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756279AbZDXVYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 17:24:07 -0400
Received: from smtp.flash.net.br ([201.46.240.48]:40542 "EHLO
	smtp.gru.flash.tv.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755671AbZDXVYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 17:24:06 -0400
Date: Fri, 24 Apr 2009 18:23:12 -0300
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Kumar Gala <galak@kernel.crashing.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: Regarding the linkstation defconfig
Message-ID: <20090424212311.GA7858@ime.usp.br>
References: <20090424065816.GA15525@ime.usp.br> <Pine.LNX.4.64.0904242158210.8309@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0904242158210.8309@axis700.grange>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Guennadi, and Kumar.

On Apr 24 2009, Guennadi Liakhovetski wrote:
> On Fri, 24 Apr 2009, Rogério Brito wrote:
> > Guennadi, since you seem to be the one responsible for the
> > linkstation/kurobox in the kernel,
> 
> That's not howI interpret my role in linkstation development /
> support.

Sorry. I thought that you were. I have, nonetheless, interest in helping
and understanding more about the platform.

> > - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
> >  01. why is anticipatory the default scheduler for linkstations when CFQ
> >      is the default scheduler for the rest of the kernel?
(...)
> >  12. wouldn't it be a good thing to enable CONFIG_PRINTK_TIME?
> > - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
> 
> As I already replied to you earlier, I am not particularly interested in 
> fine-tuning and optimisation of defconfigs. IMHO *_defconfigs are only 
> examples of board configuration, that are known to build and work. The 
> rest is up to the user / packager.

IMVHO, defconfigs should be examples of board configuration, known to
build and work (like you said) *and* be, in a way, exemplary to the
user/packager.

> > Again, please, forgive my ignorance here regarding the questions above.
> > I'm really looking for some clarification and to get things in shape
> > both on my systems and in the default kernel configuration, in general.
> 
> Feel free to submit patches with reasoning to the powerpc ML and 
> respective maintainer as per MAINTAINERS file.

I'm doing that as a reply to this message.


Thanks for your guiding, Rogério Brito.

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
