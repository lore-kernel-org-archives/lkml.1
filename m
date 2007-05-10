Return-Path: <linux-kernel-owner+w=401wt.eu-S1762132AbXEJWTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762132AbXEJWTK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 18:19:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758943AbXEJWS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 18:18:59 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4750 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110AbXEJWS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 18:18:58 -0400
Date: Thu, 10 May 2007 23:18:50 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: David Miller <davem@davemloft.net>, cw@f00f.org,
       linux-kernel@vger.kernel.org
Subject: Re: (hacky) [PATCH] silence MODPOST section mismatch warnings
Message-ID: <20070510221850.GJ29713@flint.arm.linux.org.uk>
Mail-Followup-To: Sam Ravnborg <sam@ravnborg.org>,
	David Miller <davem@davemloft.net>, cw@f00f.org,
	linux-kernel@vger.kernel.org
References: <20070510203417.GA23019@tuatara.stupidest.org> <20070510.135147.55726615.davem@davemloft.net> <20070510205427.GF29713@flint.arm.linux.org.uk> <20070510.140725.99616053.davem@davemloft.net> <20070510215920.GH29713@flint.arm.linux.org.uk> <20070510221659.GA23915@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070510221659.GA23915@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2007 at 12:16:59AM +0200, Sam Ravnborg wrote:
> On Thu, May 10, 2007 at 10:59:20PM +0100, Russell King wrote:
> > file:(section+offset): message
> 
> I like the new format - thanks!
> Did you drop the ':' after the file on purpose?

Oops, yes.

> PS. Will apply the path you submitted in next mail.

Do you want a patch with added colons?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
