Return-Path: <linux-kernel-owner+w=401wt.eu-S1759143AbYFJDOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759143AbYFJDOh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 23:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940AbYFJDO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 23:14:28 -0400
Received: from ns.suse.de ([195.135.220.2]:52233 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753555AbYFJDO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 23:14:27 -0400
Date: Mon, 9 Jun 2008 20:12:25 -0700
From: Greg KH <gregkh@suse.de>
To: Uwe Kleine-K?nig <Uwe.Kleine-Koenig@digi.com>
Cc: Paul Mundt <lethal@linux-sh.org>, "Hans J. Koch" <hjk@linutronix.de>,
       Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tglx@linutronix.de
Subject: Re: [PATCH] uio_pdrv: Unique IRQ Mode
Message-ID: <20080610031225.GF6796@suse.de>
References: <aec7e5c30806041825o4c6c859fp8380063e9384622@mail.gmail.com> <20080605090916.GA3198@local> <aec7e5c30806050246t248abc39vbc1e71d4475a0a0d@mail.gmail.com> <20080605112744.GB3198@local> <aec7e5c30806080319y7b9b6a89icacbfa67b117fb2b@mail.gmail.com> <20080608205455.GA3191@local> <aec7e5c30806081812m532882e0p7ad3ef9a74f53337@mail.gmail.com> <20080609084411.GA3223@local> <20080609090123.GA12080@linux-sh.org> <20080609123406.GB27803@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080609123406.GB27803@digi.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2008 at 02:34:06PM +0200, Uwe Kleine-K?nig wrote:
> Hello Paul,
> 
> Paul Mundt wrote:
> >                                   [...] the constructive way forward
> > seems to be to follow Uwe's suggestions and respin the patch.
> Just to let you know: I'm willing to look on a new version.  And I like
> "User IRQ Mode".


Yes, please, someone respin the patch as I am totally confused as to
what everyone is arguing about :)

thanks,

greg k-h
