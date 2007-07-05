Return-Path: <linux-kernel-owner+w=401wt.eu-S1758538AbXGEGwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758538AbXGEGwy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 02:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756908AbXGEGwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 02:52:45 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:20800 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756900AbXGEGwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 02:52:43 -0400
Date: Wed, 4 Jul 2007 23:52:14 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Keiichi Kii <k-keiichi@bx.jp.nec.com>, Netdev <netdev@vger.kernel.org>,
       Matt Mackall <mpm@selenic.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH -mm 8/9] netconsole: Update documentation for dynamic reconfigurability
Message-ID: <20070705065213.GH17650@tasint.org>
Mail-Followup-To: Satyam Sharma <ssatyam@cse.iitk.ac.in>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Keiichi Kii <k-keiichi@bx.jp.nec.com>,
	Netdev <netdev@vger.kernel.org>, Matt Mackall <mpm@selenic.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Miller <davem@davemloft.net>
References: <20070704110739.28520.5036.sendpatchset@cselinux1.cse.iitk.ac.in> <20070704110819.28520.50445.sendpatchset@cselinux1.cse.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070704110819.28520.50445.sendpatchset@cselinux1.cse.iitk.ac.in>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever come to perfection.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 04, 2007 at 04:38:19PM +0530, Satyam Sharma wrote:
> +Some examples follow (configfs is mounted at the /config mountpoint, say).

	configfs is generally expected to be mounted at
/sys/kernel/config, and it even creates that mountpoint for itself.  The
documentation should probably be consistent with that.

Joel

-- 

"Also, all of life's big problems include the words 'indictment' or
	'inoperable.' Everything else is small stuff."
	- Alton Brown

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
