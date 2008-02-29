Return-Path: <linux-kernel-owner+w=401wt.eu-S933613AbYB2RIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933613AbYB2RIi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 12:08:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755304AbYB2RI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 12:08:26 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:41555 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755221AbYB2RIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 12:08:25 -0500
Date: Fri, 29 Feb 2008 09:07:20 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Zan Lynx <zlynx@acm.org>
cc: Pavel Roskin <proski@gnu.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       Jon Masters <jcm@jonmasters.org>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 2.6.25] module: allow ndiswrapper to use GPL-only
 symbols
In-Reply-To: <1204304352.6767.21.camel@localhost>
Message-ID: <alpine.LFD.1.00.0802290906520.17889@woody.linux-foundation.org>
References: <1204236662.3612.6.camel@dv>  <alpine.LFD.1.00.0802281525170.5780@woody.linux-foundation.org>  <20080229012012.ajlsk4pow8wkkgss@webmail.spamcop.net>  <alpine.LFD.1.00.0802290807110.17889@woody.linux-foundation.org>
 <1204304352.6767.21.camel@localhost>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 29 Feb 2008, Zan Lynx wrote:
> 
> The Linux kernel itself will load proprietary modules.  It does not as a
> general rule, but it will.

.. and it doesn't export GPLONLY modules to them.

How stupid do you have to be to not understand that?

		Linus
