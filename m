Return-Path: <linux-kernel-owner+w=401wt.eu-S1752350AbYEANuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350AbYEANuH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 09:50:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbYEANt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 09:49:57 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:49010 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753457AbYEANt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 09:49:56 -0400
Date: Thu, 1 May 2008 09:49:55 -0400
To: David Newall <davidn@davidnewall.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: Slow DOWN, please!!!
Message-ID: <20080501134955.GA6957@csclub.uwaterloo.ca>
References: <20080429.211835.130816277.davem@davemloft.net> <48186E57.5070805@davidnewall.com> <alpine.LFD.1.10.0804300739350.2997@woody.linux-foundation.org> <4818B8A7.4000902@davidnewall.com> <alpine.LFD.1.10.0804301127020.2980@woody.linux-foundation.org> <4818C0BF.5020002@davidnewall.com> <alpine.LFD.1.10.0804301202200.2980@woody.linux-foundation.org> <4818C571.8040609@davidnewall.com> <alpine.LFD.1.10.0804301223220.2980@woody.linux-foundation.org> <481947AF.4090101@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <481947AF.4090101@davidnewall.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 02:01:43PM +0930, David Newall wrote:
[snip]
> Stop telling the world that 2.6.25 is ready for them when you know it's
> not. It's now ready for beta testing, and no more. Is 2.6.24 ready for
> the world yet? There are still problems being reported with it.

If a kernel release works without problems on 9999 out of 10000
machines, is it stable?  How few specific combinations of hardware are
there allowed to be with any problems before you can call it stable?
How do you know a problem you see wasn't tested by 500 people none of
whom had any problems because none of them had the hardware you do?

-- 
Len Sorensen
