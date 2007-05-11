Return-Path: <linux-kernel-owner+w=401wt.eu-S1758602AbXEKELS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602AbXEKELS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 00:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754293AbXEKELO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 00:11:14 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:59975 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753689AbXEKELN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 00:11:13 -0400
Date: Fri, 11 May 2007 06:12:07 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Miller <davem@davemloft.net>, cw@f00f.org,
       linux-kernel@vger.kernel.org
Subject: Re: (hacky) [PATCH] silence MODPOST section mismatch warnings
Message-ID: <20070511041207.GA26499@uranus.ravnborg.org>
References: <20070510203417.GA23019@tuatara.stupidest.org> <20070510.135147.55726615.davem@davemloft.net> <20070510205427.GF29713@flint.arm.linux.org.uk> <20070510.140725.99616053.davem@davemloft.net> <20070510215920.GH29713@flint.arm.linux.org.uk> <20070510221659.GA23915@uranus.ravnborg.org> <20070510221850.GJ29713@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070510221850.GJ29713@flint.arm.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 11:18:50PM +0100, Russell King wrote:
> On Fri, May 11, 2007 at 12:16:59AM +0200, Sam Ravnborg wrote:
> > On Thu, May 10, 2007 at 10:59:20PM +0100, Russell King wrote:
> > > file:(section+offset): message
> > 
> > I like the new format - thanks!
> > Did you drop the ':' after the file on purpose?
> 
> Oops, yes.
> 
> > PS. Will apply the path you submitted in next mail.
> 
> Do you want a patch with added colons?
I will add them locally - no problem.

	Sam
