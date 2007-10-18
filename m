Return-Path: <linux-kernel-owner+w=401wt.eu-S1759795AbXJRFgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759795AbXJRFgz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 01:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755476AbXJRFgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 01:36:47 -0400
Received: from rtr.ca ([76.10.145.34]:4699 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753943AbXJRFgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 01:36:46 -0400
Message-ID: <4716F0EC.9020100@rtr.ca>
Date: Thu, 18 Oct 2007 01:36:44 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [BUG] 2.6.23-git12 - Kernel oops at blk_rq_map_sg+0x270/0x4e0
References: <4716F066.5030408@linux.vnet.ibm.com>
In-Reply-To: <4716F066.5030408@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Try this patch and report back again:

    http://lkml.org/lkml/2007/10/17/269 

