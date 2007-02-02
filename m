Return-Path: <linux-kernel-owner+w=401wt.eu-S932998AbXBBKBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932998AbXBBKBl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 05:01:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933023AbXBBKBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 05:01:41 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:59806 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932998AbXBBKBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 05:01:40 -0500
X-Originating-Ip: 74.109.98.130
Date: Fri, 2 Feb 2007 05:00:36 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>, swhiteho@redhat.com
Subject: Re: [PATCH] GFS2: Fix incorrect macro name "NR_CPUS" in glock.c.
In-Reply-To: <Pine.LNX.4.64.0702020451250.12632@CPE00045a9c397f-CM001225dbafb6>
Message-ID: <Pine.LNX.4.64.0702020500080.15744@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0702020451250.12632@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Feb 2007, Robert P. J. Day wrote:

>
>   Rename the incorrect macro name "NR_CPUS" to "CONFIG_NR_CPUS".
>
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

ACK!!  ignore, ignore!  duh.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://www.fsdev.dreamhosters.com/wiki/index.php?title=Main_Page
========================================================================
