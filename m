Return-Path: <linux-kernel-owner+w=401wt.eu-S1161062AbXCVVq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161062AbXCVVq5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 17:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161108AbXCVVq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 17:46:57 -0400
Received: from eazy.amigager.de ([213.239.192.238]:57398 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161062AbXCVVq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 17:46:56 -0400
Date: Thu, 22 Mar 2007 22:46:53 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: David Brownell <david-b@pacbell.net>
Cc: linux-usb-devel@lists.sourceforge.net,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org
Subject: Re: [linux-usb-devel] possible USB regression with 2.6.21-rc4: iPod doesn't work
Message-ID: <20070322214653.GA6889@dose.home.local>
Mail-Followup-To: David Brownell <david-b@pacbell.net>,
	linux-usb-devel@lists.sourceforge.net,
	Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org
References: <20070322085451.GB10598@dose.home.local> <Pine.LNX.4.44L0.0703221539440.4669-100000@iolanthe.rowland.org> <20070322195448.GA17521@dose.home.local> <200703221429.12029.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703221429.12029.david-b@pacbell.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2007 at 14:29:11 -0700, David Brownell wrote:
> On Thursday 22 March 2007 12:54 pm, Tino Keitel wrote:
> > On Thu, Mar 22, 2007 at 15:40:40 -0400, Alan Stern wrote:
> > > 	  _Something_ is generating those overcurrent 
> > > warnings, and it sure looks like a hardware malfunction.
> > 
> > But it works with 2.6.20.
> 
> So can you bisect to find what caused the problem?

I never did use git-bisect, but maybe I find the time next week.

Regards,
Tino
