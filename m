Return-Path: <linux-kernel-owner+w=401wt.eu-S1754513AbZLCQcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbZLCQcZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 11:32:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751784AbZLCQcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 11:32:24 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:36672 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbZLCQcX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 11:32:23 -0500
Date: Thu, 3 Dec 2009 08:31:43 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       kay.sievers@vrfy.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] sysfs: fix SYSFS_DEPRECATED_V2 prompt
Message-Id: <20091203083143.3a4619a4.randy.dunlap@oracle.com>
In-Reply-To: <20091203080341.GA9675@pengutronix.de>
References: <4B0B214A.5020006@oracle.com>
	<20091203080341.GA9675@pengutronix.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4B17E7FC.0092:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Dec 2009 09:03:41 +0100 Uwe Kleine-König wrote:

> Hello,
> 
> >  config SYSFS_DEPRECATED_V2
> > -	bool "remove sysfs features which may confuse old userspace tools"
> > +	bool "enable deprecated sysfs features which may confuse old userspace tools"
> Is this better?  SYSFS_DEPRECATED_V2 enables deprecated sysfs features,
> but this is done to *not* confuse old userspace tools, isn't it?


Hm, agreed that it is still a bit ambiguous.
Feel free to send (another) patch.

thanks,
---
~Randy
