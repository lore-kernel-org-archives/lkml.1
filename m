Return-Path: <linux-kernel-owner+w=401wt.eu-S1758053AbXHXPmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053AbXHXPmw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 11:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823AbXHXPmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 11:42:44 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:43630 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbXHXPmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 11:42:43 -0400
X-Originating-Ip: 72.143.66.27
Date: Fri, 24 Aug 2007 11:32:55 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Satyam Sharma <satyam@infradead.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH] Remove superfluous definition of __setup_null_param()
 macro.
In-Reply-To: <alpine.LFD.0.999.0708242100480.20322@enigma.security.iitk.ac.in>
Message-ID: <Pine.LNX.4.64.0708241132240.31945@localhost.localdomain>
References: <Pine.LNX.4.64.0708240608090.16678@localhost.localdomain>
 <alpine.LFD.0.999.0708242100480.20322@enigma.security.iitk.ac.in>
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

On Fri, 24 Aug 2007, Satyam Sharma wrote:

>
>
> On Fri, 24 Aug 2007, Robert P. J. Day wrote:
> >
> > Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> >
> > ---
> >
> >   since i apparently removed the final remaining reference to this
> > macro in commit f4895925976977aaeda26ee2a603a99f17db500b (thanks,
> > adrian), there seems to be little value in keeping this definition
> > around.
>
> How about ...
>
>
> [PATCH] Remove superfluous definition of __setup_null_param() macro and broken (for MODULE) __setup_param()

sure.  if no one has any objections, i have no problem with that.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
