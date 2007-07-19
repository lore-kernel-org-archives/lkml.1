Return-Path: <linux-kernel-owner+w=401wt.eu-S936065AbXGSFr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936065AbXGSFr1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 01:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbXGSFrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 01:47:18 -0400
Received: from canuck.infradead.org ([209.217.80.40]:43943 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813AbXGSFrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 01:47:17 -0400
Date: Wed, 18 Jul 2007 22:31:40 -0700
From: Greg KH <greg@kroah.com>
To: James Morris <jmorris@namei.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Stephen Smalley <sds@tycho.nsa.gov>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH try #3] security: Convert LSM into a static interface
Message-ID: <20070719053140.GA3588@kroah.com>
References: <Line.LNX.4.64.0707141233490.26711@d.namei> <20070718183503.541026f8.akpm@linux-foundation.org> <Line.LNX.4.64.0707182226070.10682@d.namei>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Line.LNX.4.64.0707182226070.10682@d.namei>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2007 at 10:42:09PM -0400, James Morris wrote:
> On Wed, 18 Jul 2007, Andrew Morton wrote:
> > aww man, you passed over an opportunity to fix vast amounts of coding style
> > cruftiness.
> 
> GregKH-esque :-)

Yeah, sorry, that was when I was young and foolish and liked to bang on
the spacebar more than I should have :)

greg k-h
