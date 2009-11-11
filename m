Return-Path: <linux-kernel-owner+w=401wt.eu-S1758415AbZKKRhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758415AbZKKRhl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 12:37:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757891AbZKKRhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 12:37:40 -0500
Received: from mail.vyatta.com ([76.74.103.46]:56736 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758018AbZKKRhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 12:37:39 -0500
Date: Wed, 11 Nov 2009 09:37:24 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: William Allen Simpson <william.allen.simpson@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH resent] Documentation: rw_lock lessons learned
Message-ID: <20091111093724.4f40a48d@nehalam>
In-Reply-To: <4AFAEF78.4080807@gmail.com>
References: <4AF9C540.5090403@gmail.com>
	<20091110180646.2e5859a8@nehalam>
	<4AFAEF78.4080807@gmail.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Nov 2009 12:08:08 -0500
William Allen Simpson <william.allen.simpson@gmail.com> wrote:

> Stephen Hemminger wrote:
> > I would rather see the text in Documentation/spinlocks give an explaination
> > as to why reader/writer locks are normally not desirable. 
> > 
> > The whole document needs work to make it a developer document, rather than
> > a historical mail thread..  A good document says what should be done today,
> > and does not have old junk or ask the reader to overly new context
> > on old information.
> > 
> You wish me to merge our patches?

Sure, I am more concerned about document structure being readable than
preserving my sloppy prose.


> Or this is a second patch in a proposed series?

No. But taking more input from others (maybe Randy will help he is a good
editor) would get this back in shape.

-- 
