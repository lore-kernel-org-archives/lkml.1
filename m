Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987AbXGBJQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbXGBJQs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 05:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbXGBJQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 05:16:39 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:38998 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbXGBJQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 05:16:38 -0400
X-Originating-Ip: 72.143.66.27
Date: Mon, 2 Jul 2007 05:14:35 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Abhishek Sagar <sagar.abhishek@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       systemtap@sources.redhat.com
Subject: Re: instrumentation and kprobes really still "EXPERIMENTAL"?
In-Reply-To: <863e9df20707020154o5232e44ch37dd55811c377a8f@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0707020512320.26135@localhost.localdomain>
References: <Pine.LNX.4.64.0707011204580.32355@localhost.localdomain>
 <863e9df20707020154o5232e44ch37dd55811c377a8f@mail.gmail.com>
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

On Mon, 2 Jul 2007, Abhishek Sagar wrote:

> On 7/1/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
> > isn't kprobes mature enough to not be considered experimental anymore?
>
> That would vary from arch to arch.

fair enough.  however, at the very least, i'm thinking that the entire
"Instrumentation support" submenu can be made non-EXPERIMENTAL, while
individual entries therein can be EXPERIMENTAL on a choice-by-choice
basis or something like that.

anyway, others are welcome to play with that as they see fit.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
