Return-Path: <linux-kernel-owner+w=401wt.eu-S939846AbXGSQYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939846AbXGSQYp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 12:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765824AbXGSQY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 12:24:27 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:58918 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760316AbXGSQY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 12:24:26 -0400
X-Originating-Ip: 72.143.66.27
Date: Thu, 19 Jul 2007 12:22:01 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Arjan van de Ven <arjan@linux.intel.com>
cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: does CONFIG_UNUSED_SYMBOLS have any value anymore?
In-Reply-To: <469F8784.3030700@linux.intel.com>
Message-ID: <Pine.LNX.4.64.0707191221200.11972@localhost.localdomain>
References: <Pine.LNX.4.64.0707190849450.30763@localhost.localdomain>
 <469F749F.8030606@s5r6.in-berlin.de> <469F7918.3000503@linux.intel.com>
 <Pine.LNX.4.64.0707191133100.7047@localhost.localdomain> <469F8784.3030700@linux.intel.com>
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

On Thu, 19 Jul 2007, Arjan van de Ven wrote:

> the removal entry is/was for the symbols *marked*, not for the
> infrastructure....

ah, gotcha.  so the infrastructure itself is still useful from time to
time, then.  ok.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
