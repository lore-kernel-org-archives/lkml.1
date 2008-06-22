Return-Path: <linux-kernel-owner+w=401wt.eu-S1755292AbYFVQE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbYFVQE6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 12:04:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752447AbYFVQEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 12:04:50 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:46001 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbYFVQEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 12:04:50 -0400
Message-ID: <17241648.1214150623059.JavaMail.oracle@acsmt302.oracle.com>
Date: Sun, 22 Jun 2008 11:03:43 -0500 (CDT)
From: Randy Dunlap <randy.dunlap@oracle.com>
To: righi.andrea@gmail.com
Subject: Re: [PATCH 1/3] i/o bandwidth controller documentation
Cc: axboe@kernel.dk, containers@lists.linux-foundation.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>,
       Carl Henrik Lunde <chlunde@ping.uio.no>, matt@bluehost.com,
       roberto@unbit.it, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Divyesh Shah <dpshah@google.com>
In-Reply-To: <485CD956.3070209@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
References: <1213956335-29866-2-git-send-email-righi.andrea@gmail.com> <20080620100825.eff22c44.randy.dunlap@oracle.com> <485CD956.3070209@gmail.com>
X-Priority: 3
X-Mailer: Oracle Webmail Client(UIX)
Content-Language: en-US
Accept-Language: en-US
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- Original Message ---
> Thanks Randy, I've applied all your fixes to my local
> documentation,
> next patchset version will include them. A few small comments
> below.
> 
> >> +WARNING: per-block device limiting rules always refer to the dev_t device
> >> +number. If a block device is unplugged (i.e. a USB device) the limiting rules
> >> +associated to that device persist and they are still valid if a new device is
> > 
> > associated with (?)
> 
> what about:
> 
> ...the limiting rules defined for that device...

Hi Andrea,

Yes, that's fine.

Thanks.

