Return-Path: <linux-kernel-owner+w=401wt.eu-S1756008AbYJQQWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbYJQQWh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 12:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753267AbYJQQW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 12:22:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44988 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753155AbYJQQW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 12:22:29 -0400
Date: Fri, 17 Oct 2008 09:15:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nadia Derbey <Nadia.Derbey@bull.net>
cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 5/9] Restore memory address space
In-Reply-To: <1224233070.2634.114.camel@frecb000730.frec.bull.fr>
Message-ID: <alpine.LFD.2.00.0810170914050.3438@nehalem.linux-foundation.org>
References: <20081016181414.934C4FCC@kernel>  <20081016181421.3BA319FA@kernel> <1224233070.2634.114.camel@frecb000730.frec.bull.fr>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Nadia, please don't quote the whole diff, and then comment on just a very 
small part.

It's actually really hard to even _see_ your comments. I almost gave up, 
until I found the three lines you had written, with the 550 lines of 
quoted material..

			Linus
