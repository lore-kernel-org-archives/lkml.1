Return-Path: <linux-kernel-owner+w=401wt.eu-S933213AbXGLS5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933213AbXGLS5S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 14:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755573AbXGLS5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 14:57:09 -0400
Received: from canuck.infradead.org ([209.217.80.40]:37857 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817AbXGLS5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 14:57:08 -0400
Date: Thu, 12 Jul 2007 11:56:45 -0700
From: Greg KH <greg@kroah.com>
To: Mark Shelby <mshelby1@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel autoconfig option?
Message-ID: <20070712185645.GA23576@kroah.com>
References: <78ecab220707120718q7cfcff43u66f80711c7ec1005@mail.gmail.com> <Pine.LNX.4.64.0707121635120.25352@fbirervta.pbzchgretzou.qr> <78ecab220707120802p11ab3e1fye497f4107fe18c1d@mail.gmail.com> <20070712161402.GA18550@kroah.com> <78ecab220707120933q31a4efb5tb6dbed7a4787f5a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78ecab220707120933q31a4efb5tb6dbed7a4787f5a@mail.gmail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A: No.
Q: Should I include quotations after my reply?

On Thu, Jul 12, 2007 at 12:33:18PM -0400, Mark Shelby wrote:
>  Thanks, greg... Just wondering... If this topic comes up every 6
>  months or so -seems like there is a "need" for this sort of thing.
>  Wonder why it has not been implemented yet? Especially if as you say
>  the system calls are out there already to do it -when you know the
>  right commands to type in.

Numerous projects have been started to try to implement this, go dig
around, they might still exist.

>  Just curious... In my never ending quest to make Linux accessible to the 
>  masses
>  :-)

It turns out that the masses never build their own kernels, nor do they
need to.  The act of building kernels is quite rare for the majority of
Linux users, and rightly so.  Hopefully the book I pointed you at will
help explain how to do this properly for anyone who wishes to do this
task (it's not a simple single-step process at all.)

good luck,

greg k-h
