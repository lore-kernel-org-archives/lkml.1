Return-Path: <linux-kernel-owner+w=401wt.eu-S1764891AbXG3Wso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764891AbXG3Wso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 18:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756984AbXG3Wse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 18:48:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56052 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756784AbXG3Ws2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 18:48:28 -0400
Date: Mon, 30 Jul 2007 15:47:26 -0700
From: Greg KH <gregkh@suse.de>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Adam Kropelin <akropel1@rochester.rr.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [1/3] 2.6.23-rc1: known regressions with patches v3
Message-ID: <20070730224726.GA6715@suse.de>
References: <46AE1304.80408@googlemail.com> <20070730191322.GA24512@mail.kroptech.com> <6bffcb0e0707301536s40961661r11ed8239c85a16f2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bffcb0e0707301536s40961661r11ed8239c85a16f2@mail.gmail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2007 at 12:36:44AM +0200, Michal Piotrowski wrote:
> Hi Adam,
> 
> On 30/07/07, Adam Kropelin <akropel1@rochester.rr.com> wrote:
> > Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> > > Here is a list of some known regressions in 2.6.23-rc1
> > > with patches available.
> >
> > I don't know which list this belongs in (good: 2.6.20.6, bad 2.6.22.1),
> > but here's a clear regression with patch:
> >
> > Subject         : Edgeport UPS Monitoring Problems
> > References      : http://lkml.org/lkml/2007/7/27/334
> > Last known good : 2.6.20.6
> > Submitter       : Nick Pasich <NewsLetters@NickAndBarb.net>
> > Caused-By       :
> > Handled-By      : Adam Kropelin <akropel1@rochester.rr.com>
> > Patch           : http://lkml.org/lkml/2007/7/29/164
> > Status          : patch available
> 
> Please send this patch to Greg.

Already sent to me, and just sent to Linus about an hour ago :)

thanks,

greg k-h
