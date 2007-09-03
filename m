Return-Path: <linux-kernel-owner+w=401wt.eu-S1756072AbXICTUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbXICTUu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 15:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753868AbXICTUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 15:20:41 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:55297 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752939AbXICTUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 15:20:40 -0400
X-Belgacom-Dynamic: yes
Date: Mon, 3 Sep 2007 21:25:19 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc4-mm1
Message-ID: <20070903192519.GA2758@infomag.infomag.iguana.be>
References: <20070831215822.26e1432b.akpm@linux-foundation.org> <20070902213049.45804afd.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070902213049.45804afd.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc4/2.6.23-rc4-mm1/
> > 
> > Changes since 2.6.23-rc3-mm1:
> > 
> >  git-watchdog.patch
> 
> 
> on x86_64:
> drivers/watchdog/core/watchdog_dev.c:84: warning: format '%i' expects type 'int', but argument 5 has type 'size_t'

I'll have a look at it.

Greetings,
Wim.
