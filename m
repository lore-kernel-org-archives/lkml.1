Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276Ab0CBRM7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 12:12:59 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:20192 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577Ab0CBRM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 12:12:57 -0500
Message-ID: <4B8D4701.6060903@oracle.com>
Date: Tue, 02 Mar 2010 09:12:33 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Wim Van Sebroeck <wim@iguana.be>
Subject: Re: linux-next: Tree for March 2 (watchdog)
References: <20100302180915.1388d3f3.sfr@canb.auug.org.au>
In-Reply-To: <20100302180915.1388d3f3.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4B8D4708.00B0:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/10 23:09, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20100301:


linux-next-20100302/drivers/watchdog/wdt.c: In function 'wdt_ioctl':
linux-next-20100302/drivers/watchdog/wdt.c:370: error: assignment of read-only variable 'ident'
linux-next-20100302/drivers/watchdog/wdt.c:373: error: assignment of read-only variable 'ident'
linux-next-20100302/drivers/watchdog/wdt.c:375: error: assignment of read-only variable 'ident'
make[3]: *** [drivers/watchdog/wdt.o] Error 1



-- 
~Randy
