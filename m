Return-Path: <linux-kernel-owner+w=401wt.eu-S1756205AbXH1RPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205AbXH1RPN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 13:15:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbXH1RPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 13:15:01 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:34281 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbXH1RPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 13:15:00 -0400
X-Originating-Ip: 72.143.66.27
Date: Tue, 28 Aug 2007 13:03:18 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ok to kill "ether=" kernel parm?
In-Reply-To: <46D45111.2040600@zytor.com>
Message-ID: <Pine.LNX.4.64.0708281300030.18151@localhost.localdomain>
References: <Pine.LNX.4.64.0708280307350.3354@localhost.localdomain>
 <46D45111.2040600@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	timed out)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Aug 2007, H. Peter Anvin wrote:

> Robert P. J. Day wrote:
> >   given that "ether=" has been officially obsolete since 2.6.18
> > (replaced by "netdev="), is there any reason to keep it around?
> > or can it be blasted?
>
> That sounds like way too short of a timeline for breaking people's
> working boot setup.  For a lot of people, 2.6.18->current is going
> to be a single step.

actually, now that i look more closely at the code browser at
lxr.linux.no, "ether=" has been listed as "obsolete" since *at least*
2.6.10.  not to sound unsympathetic but anyone who tries to jump from
2.6.10 to 2.6.24 in one step deserves what they get.  :-)

ok, that was cruel, but you see my point, right?

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
