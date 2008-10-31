Return-Path: <linux-kernel-owner+w=401wt.eu-S1753237AbYJaU3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbYJaU3T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 16:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752305AbYJaU3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 16:29:12 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:26005 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052AbYJaU3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 16:29:10 -0400
Date: Fri, 31 Oct 2008 13:28:39 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh <greg@kroah.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>
Subject: Re: linux-next: Tree for October 31 (repeat build failures)
Message-Id: <20081031132839.8c07b0aa.randy.dunlap@oracle.com>
In-Reply-To: <20081031185613.7892fd8d.sfr@canb.auug.org.au>
References: <20081031185613.7892fd8d.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Oct 2008 18:56:13 +1100 Stephen Rothwell wrote:

The only randconfig build failures that I see today (on i386 & x86_64)
are repeats of:

hp-plus undefined references:
  http://marc.info/?l=linux-next&m=122513607505680&w=2

staging/go7007/go7007-v4l2:
  http://marc.info/?l=linux-next&m=122513515404158&w=2

net/9p rdma_* undefined references with CONFIG_NET=y and CONFIG_INET=n:
  http://marc.info/?l=linux-next&m=122504699904105&w=2

---
~Randy
