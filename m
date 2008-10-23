Return-Path: <linux-kernel-owner+w=401wt.eu-S1755146AbYJWGb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146AbYJWGb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 02:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752376AbYJWGbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 02:31:48 -0400
Received: from kroah.org ([198.145.64.141]:42682 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751915AbYJWGbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 02:31:47 -0400
Date: Wed, 22 Oct 2008 23:26:55 -0700
From: Greg KH <greg@kroah.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>, otus-devel@venema.h4ckr.net
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Release of Atheros 802.11n USB Linux driver
Message-ID: <20081023062655.GA8039@kroah.com>
References: <43e72e890810211904x7bd243dem68dfcfe7a795ec6f@mail.gmail.com> <20081022065045.GA2400@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022065045.GA2400@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2008 at 11:50:45PM -0700, Greg KH wrote:
> On Tue, Oct 21, 2008 at 07:04:17PM -0700, Luis R. Rodriguez wrote:
> > We would like to see our Atheros 802.11n USB Linux driver upstream
> > however we need help with this so we are releasing our Atheros 11n USB
> > Otus Linux driver under the ISC to the community. The goal is to work
> > with the community to help move this forward upstream. We are hoping
> > for community help and leadership on this (*cough*).
> 
> Yeah!
> 
> I'll grab this and put it in drivers/staging/ so it gets some users and
> more developers to help out with it.

Ok, it seems to need some basic work to merely build properly on
"modern" kernel versions.

So, how should we do this if I want to move it into staging?  Can I just
take a snapshot of what you have in this repo, move it in-kernel, fix
the build errors and apply that patch (as your contribution of course)?

Then future development can go off of the in-kernel version?  Or do you
plan to keep this git tree active somehow?

thanks,

greg k-h
