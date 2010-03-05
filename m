Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab0CEBXM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 20:23:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60849 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751357Ab0CEBXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 20:23:10 -0500
Date: Thu, 4 Mar 2010 17:22:30 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Luc Verhaegen <libv@skynet.be>
cc: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
In-Reply-To: <20100305011627.GA524@skynet.be>
Message-ID: <alpine.LFD.2.00.1003041721290.3768@localhost.localdomain>
References: <20100304105624.70fe845e@jbarnes-piketon> <alpine.LFD.2.00.1003041101390.3751@localhost.localdomain> <21d7e9971003041125x1aee3b3ew1e407ca6695e10fc@mail.gmail.com> <alpine.LFD.2.00.1003041142250.3751@localhost.localdomain>
 <21d7e9971003041406n53d9cae0h53374abf3dca494e@mail.gmail.com> <alpine.LFD.2.00.1003041554490.3751@localhost.localdomain> <1267748927.3496.6.camel@nisroch> <alpine.LFD.2.00.1003041635280.3751@localhost.localdomain> <20100305005617.GA31883@skynet.be>
 <alpine.LFD.2.00.1003041702110.3659@localhost.localdomain> <20100305011627.GA524@skynet.be>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 5 Mar 2010, Luc Verhaegen wrote:
> 
> In an ideal world, you shouldn't be forced to update anything except 
> some/all of the driver bits.
> 
> But the fact that libdrm is lumped together as it is, and that mesa is a 
> monolith, forces you to update a more significant portion of your 
> system. You have to resort to some serious manual labour to get around 
> that atm.

Ok, that probably explains my messy screen and failure with the above 
simplistic approach - I didn't do the whole mesa thing, I just did the 
drivers.

			Linus
