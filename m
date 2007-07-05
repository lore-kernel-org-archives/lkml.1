Return-Path: <linux-kernel-owner+w=401wt.eu-S1760823AbXGEJQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760823AbXGEJQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 05:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758884AbXGEJQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 05:16:43 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:51186 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753819AbXGEJQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 05:16:42 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
Date: Thu, 5 Jul 2007 15:08:11 +0530 (IST)
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: Joel Becker <Joel.Becker@oracle.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Keiichi Kii <k-keiichi@bx.jp.nec.com>, Netdev <netdev@vger.kernel.org>,
       Matt Mackall <mpm@selenic.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH -mm 8/9] netconsole: Update documentation for dynamic
 reconfigurability
In-Reply-To: <20070705065213.GH17650@tasint.org>
Message-ID: <Pine.LNX.4.64.0707051506080.15925@cselinux1.cse.iitk.ac.in>
References: <20070704110739.28520.5036.sendpatchset@cselinux1.cse.iitk.ac.in>
 <20070704110819.28520.50445.sendpatchset@cselinux1.cse.iitk.ac.in>
 <20070705065213.GH17650@tasint.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jul 2007, Joel Becker wrote:
> On Wed, Jul 04, 2007 at 04:38:19PM +0530, Satyam Sharma wrote:
> > +Some examples follow (configfs is mounted at the /config mountpoint, say).
> 
> 	configfs is generally expected to be mounted at
> /sys/kernel/config, and it even creates that mountpoint for itself.  The
> documentation should probably be consistent with that.

Ok, will do that in the next iteration -- I'll wait for a couple more
days for comments from others, and then post the v2 patches sometime
during the weekend.

Satyam
