Return-Path: <linux-kernel-owner+w=401wt.eu-S1765922AbXHXSBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765922AbXHXSBa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 14:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756416AbXHXSBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 14:01:22 -0400
Received: from eazy.amigager.de ([213.239.192.238]:42360 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760215AbXHXSBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 14:01:22 -0400
Date: Fri, 24 Aug 2007 20:01:20 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: Greg KH <gregkh@suse.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [4/4] 2.6.23-rc3: known regressions v3
Message-ID: <20070824180120.GA13916@dose.home.local>
Mail-Followup-To: Greg KH <gregkh@suse.de>,
	Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Oliver Neukum <oliver@neukum.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <46CF0DEF.5040107@googlemail.com> <46CF17A0.2060503@googlemail.com> <20070824175608.GA5333@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070824175608.GA5333@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2007 at 10:56:08 -0700, Greg KH wrote:
> On Fri, Aug 24, 2007 at 07:38:40PM +0200, Michal Piotrowski wrote:
> > Hi all,
> > 
> > Here is a list of some known regressions in 2.6.23-rc3.
> 
> First off, thanks so much for tracking these, it can't be an easy job,
> but one that is really needed.  Keep up the great work.
> 
> > USB
> > 
> > Subject         : 2.6.23-rc1: USB hard disk broken
> > References      : http://lkml.org/lkml/2007/7/25/62
> > Last known good : ?
> > Submitter       : Tino Keitel <tino.keitel@gmx.de>
> > Caused-By       : ?
> > Handled-By      : Oliver Neukum <oliver@neukum.org>
> > Status          : unknown
> 
> Last I heard was that Tino was going to try to do further testing, but
> as he hasn't responded in a few weeks, I'd mark this one down to,
> "unknown and unreproducable".  Unless someone else knows more?

I was at least able to reproduce it with 2.6.23-rc2. And I tried it
hard with 2.6.22 but it didn't happen.

Regards,
Tino
