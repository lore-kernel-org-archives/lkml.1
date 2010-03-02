Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177Ab0CBUqr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 15:46:47 -0500
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:64742 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753510Ab0CBUqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 15:46:45 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAJoHjUtR9cLb/2dsb2JhbACbAXS/Pg2EbgQ
Date: Tue, 2 Mar 2010 21:46:42 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for March 2 (watchdog)
Message-ID: <20100302204642.GI7459@infomag.iguana.be>
References: <20100302180915.1388d3f3.sfr@canb.auug.org.au> <4B8D4701.6060903@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B8D4701.6060903@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

Overlooked that one. Fixed now.

Thanks,
Wim.

> On 03/01/10 23:09, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20100301:
> 
> 
> linux-next-20100302/drivers/watchdog/wdt.c: In function 'wdt_ioctl':
> linux-next-20100302/drivers/watchdog/wdt.c:370: error: assignment of read-only variable 'ident'
> linux-next-20100302/drivers/watchdog/wdt.c:373: error: assignment of read-only variable 'ident'
> linux-next-20100302/drivers/watchdog/wdt.c:375: error: assignment of read-only variable 'ident'
> make[3]: *** [drivers/watchdog/wdt.o] Error 1
> 
> 
> 
> -- 
> ~Randy
