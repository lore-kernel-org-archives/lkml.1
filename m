Return-Path: <linux-kernel-owner+w=401wt.eu-S1759858AbXHNNsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759858AbXHNNsT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 09:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbXHNNsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 09:48:07 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55042 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbXHNNsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 09:48:05 -0400
Subject: Re: [v4l-dvb-maintainer] [PATCH] [534/2many] MAINTAINERS - VIDEO
	FOR LINUX
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Joe Perches <joe@perches.com>, Michael Krufky <mkrufky@linuxtv.org>,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
       v4l-dvb-maintainer@linuxtv.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org
In-Reply-To: <1a297b360708140635h3f7d00e5sa8c98a84340b8ff5@mail.gmail.com>
References: <46bffca0.bx1Cr4B33dN1FJPN%joe@perches.com>
	 <1187028910.664.11.camel@gaivota> <1187030038.10249.237.camel@localhost>
	 <1a297b360708131222t55be6fbax78a6659762a98e7e@mail.gmail.com>
	 <1187056816.10249.366.camel@localhost> <46C10E85.2070902@linuxtv.org>
	 <1187059484.10249.370.camel@localhost> <1187098031.7287.10.camel@gaivota>
	 <1a297b360708140635h3f7d00e5sa8c98a84340b8ff5@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 14 Aug 2007 10:47:49 -0300
Message-Id: <1187099269.7287.13.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.6.1-1mdv2008.0 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> > F: drivers/media/*
> 
> 
> This is NOT OK !

This IS ok. You just need to read the definition of the 'F' tag:

F: Files and directories with wildcard patterns.
   A trailing slash includes all files and subdirectory files.
        F:      drivers/net/    all files in and below drivers/net
        F:      drivers/net/*   all files in drivers/net, but not below
        F:      */net/*         all files in "any top level directory"/net
   One pattern per line.  Multiple F: lines acceptable.

This tag just includes Kconfig and Makefile.

-- 
Cheers,
Mauro

