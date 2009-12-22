Return-Path: <linux-kernel-owner+w=401wt.eu-S1751930AbZLVGAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930AbZLVGAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 01:00:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbZLVGAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 01:00:39 -0500
Received: from kroah.org ([198.145.64.141]:37203 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285AbZLVGAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 01:00:38 -0500
Date: Mon, 21 Dec 2009 21:31:55 -0800
From: Greg KH <greg@kroah.com>
To: Milan Broz <mbroz@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>,
       device-mapper development <dm-devel@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] Re: dm: sysfs add empty release function to avoid
	debug warning
Message-ID: <20091222053155.GA16888@kroah.com>
References: <200912151735.nBFHZ8XP018683@hera.kernel.org> <20091216004739.GB4898@kroah.com> <4B28AC09.2000302@redhat.com> <20091216134538.GA20857@kroah.com> <4B290B95.10306@redhat.com> <20091216174632.GA12473@kroah.com> <4B29299B.5080704@redhat.com> <20091217003021.GB3512@kroah.com> <4B2A518B.1030800@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B2A518B.1030800@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 04:43:07PM +0100, Milan Broz wrote:
> On 12/17/2009 01:30 AM, Greg KH wrote:
> > On Wed, Dec 16, 2009 at 07:40:27PM +0100, Milan Broz wrote:
> >> On 12/16/2009 06:46 PM, Greg KH wrote:
> >>> You will find that all of these are modules, right?  That's being worked
> >>> on still.
> >>
> >> probably. I see that this implementation is in kernel since import to git...
> > 
> > And you will also note that I didn't paper over the issue by trying to
> > provide an empty release function :)
> 
> Alasdair, can we request revert of that last patch for now
> (which introduced the empty release function)?

Ping?  Any word on the revert?

thanks,

greg k-h
