Return-Path: <linux-kernel-owner+w=401wt.eu-S1756203AbXH2OjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203AbXH2OjM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 10:39:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbXH2Oi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 10:38:59 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:39669 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbXH2Oi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 10:38:58 -0400
X-Originating-Ip: 72.143.66.27
Date: Wed, 29 Aug 2007 10:28:13 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Denys Vlasenko <vda.linux@googlemail.com>
cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ok to kill "ether=" kernel parm?
In-Reply-To: <200708291535.41594.vda.linux@googlemail.com>
Message-ID: <Pine.LNX.4.64.0708291027180.21022@localhost.localdomain>
References: <Pine.LNX.4.64.0708280307350.3354@localhost.localdomain>
 <46D45A02.6010306@zytor.com> <Pine.LNX.4.64.0708281347390.20783@localhost.localdomain>
 <200708291535.41594.vda.linux@googlemail.com>
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

On Wed, 29 Aug 2007, Denys Vlasenko wrote:

> Add a printk("Deprecated, use netdev=xxx\n"); to the handler.
> After 1-2 years you can remove ether=xxx.

actually, i was just about to do that, along the lines of what was
done with "time" -> "printk.time".  coming soonish.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
