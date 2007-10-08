Return-Path: <linux-kernel-owner+w=401wt.eu-S1756031AbXJHRgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031AbXJHRgm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 13:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752754AbXJHRgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 13:36:35 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41935 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbXJHRge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 13:36:34 -0400
Subject: Re: [stable] [PATCH] lockdep: fix mismatched
	lockdep_depth/curr_chain_hash
From: Peter Zijlstra <peterz@infradead.org>
To: Greg KH <greg@kroah.com>
Cc: Gregory Haskins <ghaskins@novell.com>, stable <stable@kernel.org>,
       mingo@elte.hu, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20071008172424.GA6692@kroah.com>
References: <20071005034058.20275.21559.stgit@ghaskins-t60p.haskins.net>
	 <1191576686.22357.64.camel@twins>  <20071008172424.GA6692@kroah.com>
Content-Type: text/plain; charset=utf-8
Date: Mon, 08 Oct 2007 19:36:10 +0200
Message-Id: <1191864970.5797.1.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-10-08 at 10:24 -0700, Greg KH wrote:
> On Fri, Oct 05, 2007 at 11:31:26AM +0200, Peter Zijlstra wrote:
> > 
> > Stable team,
> > 
> > please consider this patch for the next 22-stable.
> 
> I don't see this patch in Linus's upstream tree.  We need it there to be
> able to accept it for -stable.  Or is this just a bugfix of other things
> that are already in his tree?

I send Linus a similar patch, haven´t seem him pick it up yet.
I´ll notify you when and if he picks it up.



