Return-Path: <linux-kernel-owner+w=401wt.eu-S939966AbXGaAMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939966AbXGaAMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 20:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932826AbXGaAMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 20:12:40 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56555 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754534AbXGaAMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 20:12:39 -0400
Date: Mon, 30 Jul 2007 17:12:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Satyam Sharma <satyam@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Keiichi Kii <k-keiichi@bx.jp.nec.com>, Netdev <netdev@vger.kernel.org>,
       Joel Becker <joel.becker@oracle.com>, Matt Mackall <mpm@selenic.com>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH v3 -mm 0/9] netconsole: Multiple targets and dynamic
 reconfigurability
Message-Id: <20070730171211.97e2f8f0.akpm@linux-foundation.org>
In-Reply-To: <20070730024741.10828.48209.sendpatchset@enigma.security.iitk.ac.in>
References: <20070730024741.10828.48209.sendpatchset@enigma.security.iitk.ac.in>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jul 2007 08:17:41 +0530
Satyam Sharma <satyam@infradead.org> wrote:

> [0/9] netconsole: Multiple targets and dynamic reconfigurability
> 
> This is v3 of the patchset

That all looks pretty reasonable, thanks.

Are we all comfortable with the attributions?  As I have it now, everything
will go in as having been authored by yourself.  There is no formal (ie:
understood-by-git) way of recording joint authorship, unfortunately.  But one
can make a record of such things in the changelog.

I'll queue this material up in the to-be-sent-to-davem queue.
