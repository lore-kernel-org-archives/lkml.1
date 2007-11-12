Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbXKLTl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbXKLTl7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 14:41:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751170AbXKLTlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 14:41:50 -0500
Received: from rtr.ca ([76.10.145.34]:1796 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156AbXKLTlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 14:41:49 -0500
Message-ID: <4738AC7C.2060402@rtr.ca>
Date: Mon, 12 Nov 2007 14:41:48 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: linux-ext4@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>,
       sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com
Subject: Re: Oops 2.6.23.1 in ext3+jbd at journal_put_journal_head
References: <4738AC21.8070507@rtr.ca>
In-Reply-To: <4738AC21.8070507@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> A one-time event thus far, happened under very heavy I/O,
> Dell i9400 Core2Duo notebook w/3GB ram, single SATA drive with ext3.
> Had to cycle power to get it back and see this Oops in the syslog:
> 
> : BUG: unable to handle kernel paging request at virtual address 430a7261
...

Note that the drive is clean, no bad sectors, no errors in S.M.A.R.T. logs.
