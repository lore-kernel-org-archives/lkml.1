Return-Path: <linux-kernel-owner+w=401wt.eu-S1757477AbZAVRQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477AbZAVRQZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 12:16:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754711AbZAVRQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 12:16:17 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:43991 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633AbZAVRQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 12:16:16 -0500
Message-ID: <4978A9D0.2050103@oracle.com>
Date: Thu, 22 Jan 2009 09:16:00 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>
Subject: Re: linux-next: Tree for January 22 (staging/android)
References: <20090122180543.1ab0baa6.sfr@canb.auug.org.au>
In-Reply-To: <20090122180543.1ab0baa6.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4978A9D3.0277:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20090121:

drivers/staging/android/timed_gpio.c: In function 'gpio_enable_show':
drivers/staging/android/timed_gpio.c:52: error: 'ktime_t' has no member named 'tv'
drivers/staging/android/timed_gpio.c:52: error: 'ktime_t' has no member named 'tv'

-- 
~Randy
