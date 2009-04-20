Return-Path: <linux-kernel-owner+w=401wt.eu-S1758713AbZDTW6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713AbZDTW6v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 18:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755725AbZDTW6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 18:58:42 -0400
Received: from smtp.flash.net.br ([201.46.240.48]:37062 "EHLO
	smtp.gru.flash.tv.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450AbZDTW6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 18:58:42 -0400
Date: Mon, 20 Apr 2009 19:57:58 -0300
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, Michael Tokarev <mjt@tls.msk.ru>,
       Mark Lord <lkml@rtr.ca>, linux-kernel@vger.kernel.org
Subject: Re: Quick question about libata and hdparm
Message-ID: <20090420225758.GA15776@ime.usp.br>
References: <E693AEE4-7895-4650-A1DC-1FB16D409D5B@ime.usp.br> <49EB9758.3020506@garzik.org> <20090420173526.GA7935@ime.usp.br> <200904202231.25670.bzolnier@gmail.com> <20090420221955.2c71bd26@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090420221955.2c71bd26@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 20 2009, Alan Cox wrote:
> > DISCLAIMER: I'm not handling this bugreport, this is best
> > done by pata_pdc202xx_old Maintainer or libata Maintainer.
> 
> Be that as it may thanks - thats well spotted and definitely a bug.

Ok, I patched the 30-rc2 tarball. It is taking a looong time to compile
(even with very few components selected).

But I will report how things go "in a few moments" (for some values of
"few moments"). :-)

Thanks for all the attention. You guys rock.

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
