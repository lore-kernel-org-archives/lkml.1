Return-Path: <linux-kernel-owner+w=401wt.eu-S1755917AbXIDVRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917AbXIDVRA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 17:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755059AbXIDVQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 17:16:53 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:45241 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755044AbXIDVQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 17:16:52 -0400
X-Belgacom-Dynamic: yes
Date: Tue, 4 Sep 2007 23:21:32 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Satyam Sharma <satyam@infradead.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23-rc4-mm1
Message-ID: <20070904212132.GA4451@infomag.infomag.iguana.be>
References: <20070831215822.26e1432b.akpm@linux-foundation.org> <20070902213049.45804afd.randy.dunlap@oracle.com> <20070903192519.GA2758@infomag.infomag.iguana.be> <alpine.LFD.0.999.0709040356220.8504@enigma.security.iitk.ac.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0709040356220.8504@enigma.security.iitk.ac.in>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> * Fix this warning:
> 
>   drivers/watchdog/core/watchdog_dev.c:84:
>   warning: format '%i' expects type 'int', but argument 5 has type 'size_t'
> 
> * CONFIG_xxx options are directly usable by preprocessor directives.

Patch works for me. I applied it to the linux-2.6-watchdog-mm tree.

Greetings,
Wim.
