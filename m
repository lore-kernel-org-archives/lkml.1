Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab0CFWEa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 17:04:30 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59440 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751834Ab0CFWE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 17:04:29 -0500
Date: Sat, 6 Mar 2010 14:04:18 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: =?ISO-8859-15?Q?J=F6rn_Engel?= <joern@logfs.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: Please pull logfs tree
In-Reply-To: <20100306213501.GB21570@logfs.org>
Message-ID: <alpine.LFD.2.00.1003061403110.31447@localhost.localdomain>
References: <20100306210459.GA21570@logfs.org> <alpine.LFD.2.00.1003061319530.31447@localhost.localdomain> <20100306213501.GB21570@logfs.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 6 Mar 2010, Jörn Engel wrote:
> 
> Ok, learned something new again.  Thank you for doing the trivial merge
> that would have taken me days to figure out. :)

Heh. I do those things day in and day out. That was a really easy merge. 
And I'm happy you pointed it out beforehand, so that we didn't get a 
separate commit and non-bisectable history.

			Linus
