Return-Path: <linux-kernel-owner+w=401wt.eu-S1751795Ab0ABTWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795Ab0ABTWT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 14:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751475Ab0ABTWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 14:22:19 -0500
Received: from kroah.org ([198.145.64.141]:54673 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468Ab0ABTWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 14:22:18 -0500
Date: Sat, 2 Jan 2010 11:21:29 -0800
From: Greg KH <greg@kroah.com>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Peter Paul <abnominales@web.de>, linux-kernel@vger.kernel.org
Subject: Re: [patch staging] BCM70010 (crystalhd) Linux Driver
Message-ID: <20100102192129.GA17503@kroah.com>
References: <523138909@web.de>
 <20091231131852.GB32492@centrinvest.ru>
 <20100101001931.GA1290@kroah.com>
 <1a297b361001020805y6b00af83g81cf8492aa73bc3b@mail.gmail.com>
 <20100102163449.GB5172@kroah.com>
 <1a297b361001021017y746e4acdsfcf307b0f363e21d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1a297b361001021017y746e4acdsfcf307b0f363e21d@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 02, 2010 at 10:17:04PM +0400, Manu Abraham wrote:
> On Sat, Jan 2, 2010 at 8:34 PM, Greg KH <greg@kroah.com> wrote:
> > On Sat, Jan 02, 2010 at 08:05:38PM +0400, Manu Abraham wrote:
> >> Hi Greg,
> >>
> >> > I'm glad to do so if someone wants to help work on it there and shephard
> >> > it into the main kernel tree.
> >>
> >> Please find the initial round of cleaned up patches for staging,
> >> applied against linux-next.
> >
> > Did you really author this driver?  If so, that's fine, just checking.
> > If not, please put the correct authorship "From:" in the patch.
> 
> I am not the author of the driver. I just picked it up and cleaned it
> up for Coding style changes for it to be included.

Can we try to figure out who the author is and please credit them?

> > Also, please break up patches to be sent one-per-email so they can be
> > properly applied, and also only have them do one thing (your 4th patch
> > fixed up coding style issues and added the driver to the build.)
> 
> Okay, I will resend them.
> 
> > Also, can you add a TODO file to the driver directory stating what is
> > needed to be done, and who to contact about it?
> 
> I will test the device over the coming week and add in a TODO after that.

I need a TODO before I can accept the patches, sorry.

thanks,

greg k-h
