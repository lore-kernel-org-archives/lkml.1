Return-Path: <linux-kernel-owner+w=401wt.eu-S1030384AbXCLPiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030384AbXCLPiz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 11:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030390AbXCLPiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 11:38:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:56356 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030384AbXCLPiy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 11:38:54 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: Greg KH <greg@kroah.com>
Subject: Re: [BUG} usb-serial regression in 2.6.21-rc2-git3
Date: Mon, 12 Mar 2007 16:38:52 +0100
User-Agent: KMail/1.9.1
Cc: Mark Lord <lkml@rtr.ca>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <45F56E37.9050506@rtr.ca> <20070312152920.GA29597@kroah.com>
In-Reply-To: <20070312152920.GA29597@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703121638.54076.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 12. März 2007 16:29 schrieb Greg KH:
> On Mon, Mar 12, 2007 at 11:13:59AM -0400, Mark Lord wrote:
> > Oliver Neukum wrote:
> > >Am Montag, 12. M??rz 2007 15:56 schrieb Mark Lord:
> > >>Still no improvement on the b0rken usb-serial resume support in -rc*.
> > >
> > >Have you applied the fixes in Greg's current tree?
> > 
> > I don't know anything about any "current tree"
> > other than the 2.6.21-rc3-git* on kernel.org.
> 
> And all of those fixes Oliver is referring to should be in anything
> older than 2.6.21-rc3-git6.  So we have a different problem here than
> what people were seeing before.

Older than 2.6.21-rc3-git6? Did you throw them out? Why?

	Regards
		Oliver
