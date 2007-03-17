Return-Path: <linux-kernel-owner+w=401wt.eu-S933593AbXCQCAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933593AbXCQCAL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 22:00:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933647AbXCQCAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 22:00:10 -0400
Received: from wilma.widomaker.com ([204.17.220.5]:2330 "EHLO
	wilma.widomaker.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933593AbXCQCAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 22:00:09 -0400
Date: Fri, 16 Mar 2007 22:00:06 -0400
From: Charles Shannon Hendrix <shannon@widomaker.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: SATA problems in 2.6.20.3
Message-ID: <20070316220006.52288001@daydream.goid.lan>
In-Reply-To: <45FB2BD9.2070803@shaw.ca>
References: <fa.lqWgqhKIlhgG3TXcvhBc/T7bPFE@ifi.uio.no>
	<45FB2BD9.2070803@shaw.ca>
Organization: Big Endian
X-Mailer: Claws Mail 2.8.0 (GTK+ 2.8.20; i486-slackware-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Mar 2007 17:44:25 -0600
Robert Hancock <hancockr@shaw.ca> wrote:

> Charles Shannon Hendrix wrote:
> > I normally run a modified 2.6.19 kernel and it works great.
> > 
> > I recently tried 2.6.20 and had severe SATA problems with it.
> > 
> > Yesterday I tried 2.6.20.3, and the problems are still there.
> 
> Can you try 2.6.21-rc and see if the problem is fixed in those kernels?

OK.

sata_nv.adma=0 let's me run 2.6.20.3 for now.

I'll test 2.6.21-rc<whatever> tomorrow some time.




-- 
shannon           | Work for something because it is good, not just because 
                  | it stands a chance to succeed. 
                  |        -- Vaclav Havel
