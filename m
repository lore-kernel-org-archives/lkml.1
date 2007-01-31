Return-Path: <linux-kernel-owner+w=401wt.eu-S932930AbXAaXAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932930AbXAaXAW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 18:00:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933284AbXAaXAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 18:00:22 -0500
Received: from thunk.org ([69.25.196.29]:35260 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932930AbXAaXAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 18:00:21 -0500
Date: Wed, 31 Jan 2007 18:00:15 -0500
From: Theodore Tso <tytso@mit.edu>
To: Greg KH <greg@kroah.com>
Cc: Nicolas Mailhot <nicolas.mailhot@laposte.net>,
       linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
Message-ID: <20070131230014.GD20514@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Greg KH <greg@kroah.com>,
	Nicolas Mailhot <nicolas.mailhot@laposte.net>,
	linux-kernel@vger.kernel.org
References: <32793.192.54.193.51.1170248792.squirrel@rousalka.dyndns.org> <20070131201258.GB15128@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070131201258.GB15128@kroah.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 31, 2007 at 12:12:58PM -0800, Greg KH wrote:
> 
> This kind of offer has _always_ been there for out-of-tree GPL drivers.
> I have contacted many different groups and driver authors over the years
> to offer my help in trying to get their code into the mainline kernel.
> 
> Some take me up on the offer, others ignore it, and still others activly
> refuse to do so, saying they want to stay out-of-the tree (lirc is one
> of these examples...)

I think the point is that if we are offering free development effort
to write a driver which goes into mainline, maybe we should provide
more than "providing rules and guidelines" so that people can spend
engineering $$$ to get the driver into mainline.   

More specifically, Dave said that it "seemed rude" to just take the
driver and send updates, but maybe the best way of dealing with
out-of-tree drivers like lirc is to treat the out-of-tree drivers as a
kind of spec release, and just have someone in the community forcibly
take the code, fix it up, and then get it merged.  Maybe it's being
"rude", but so is not responding to requests to get it merged.

							- Ted
