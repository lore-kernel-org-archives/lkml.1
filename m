Return-Path: <linux-kernel-owner+w=401wt.eu-S964907AbXG2Vv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964907AbXG2Vv0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 17:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936138AbXG2VvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 17:51:19 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:38789 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936064AbXG2VvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 17:51:18 -0400
X-Originating-Ip: 72.143.66.27
Date: Sun, 29 Jul 2007 17:48:27 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Jesper Juhl <jesper.juhl@gmail.com>
cc: Ian Molton <spyro@f2s.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] arm26: remove duplicate include of linux/module.h
In-Reply-To: <200707292343.18706.jesper.juhl@gmail.com>
Message-ID: <Pine.LNX.4.64.0707291747470.8611@localhost.localdomain>
References: <200707292343.18706.jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Jul 2007, Jesper Juhl wrote:

> Hi,
>
> This patch removes the duplicate inclusion of
> linux/module.h from arm26.

is it really worth doing any cleanup of arm26 given the recent
discussion of tossing it entirely?

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
