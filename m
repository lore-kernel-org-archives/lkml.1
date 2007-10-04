Return-Path: <linux-kernel-owner+w=401wt.eu-S1759553AbXJDKG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759553AbXJDKG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 06:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756200AbXJDKGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 06:06:51 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:59376 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843AbXJDKGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 06:06:50 -0400
X-Originating-Ip: 99.236.101.138
Date: Thu, 4 Oct 2007 06:04:09 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Pavel Machek <pavel@ucw.cz>
cc: linux-kernel@vger.kernel.org, bwalle@suse.de,
       Andrew Morton <akpm@osdl.org>
Subject: Re: kdump: documentation cleanups
In-Reply-To: <20071004094206.GA564@elf.ucw.cz>
Message-ID: <Pine.LNX.4.64.0710040602510.11078@localhost.localdomain>
References: <20071004094206.GA564@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Oct 2007, Pavel Machek wrote:

> -On powererpc systems when a soft-reset is generated, die() is called by all cpus
> +On powerpc systems when a soft-reset is generated, die() is called by all cpus
                                                                             ^^^

  i thought the recent standard was to use the capitalized form of
"CPU".

rday
-- 

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
