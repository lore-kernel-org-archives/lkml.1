Return-Path: <linux-kernel-owner+w=401wt.eu-S1764963AbXGJJmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764963AbXGJJmp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 05:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763084AbXGJJme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 05:42:34 -0400
Received: from waste.org ([66.93.16.53]:43372 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761737AbXGJJmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 05:42:33 -0400
Date: Tue, 10 Jul 2007 04:41:43 -0500
From: Matt Mackall <mpm@selenic.com>
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Keiichi Kii <k-keiichi@bx.jp.nec.com>, Netdev <netdev@vger.kernel.org>,
       Joel Becker <joel.becker@oracle.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2 -mm 4/9] netconsole: Add some useful tips to documentation
Message-ID: <20070710094142.GM11115@waste.org>
References: <20070710091920.23907.96483.sendpatchset@cselinux1.cse.iitk.ac.in> <20070710091941.23907.45658.sendpatchset@cselinux1.cse.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070710091941.23907.45658.sendpatchset@cselinux1.cse.iitk.ac.in>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2007 at 02:49:41PM +0530, Satyam Sharma wrote:
> From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
> 
> [4/9] netconsole: Add some useful tips to documentation
> 
> Add some useful general-purpose tips.
> 
> Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
> Cc: Keiichi Kii <k-keiichi@bx.jp.nec.com>

Acked-by: Matt Mackall <mpm@selenic.com>

As long as we're on the subject, I've been meaning to add a note
telling people to set their console log level to something useful, as
having that set too low is the most common problem people encounter.

-- 
Mathematics is the supreme nostalgia of our time.
