Return-Path: <linux-kernel-owner+w=401wt.eu-S1752951Ab0ACVP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951Ab0ACVP5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 16:15:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742Ab0ACVP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 16:15:56 -0500
Received: from kroah.org ([198.145.64.141]:52024 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516Ab0ACVP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 16:15:56 -0500
Date: Sun, 3 Jan 2010 09:34:17 -0800
From: Greg KH <greg@kroah.com>
To: jarod@wilsonet.com
Cc: Jon Smirl <jonsmirl@gmail.com>, Manu Abraham <abraham.manu@gmail.com>,
       Peter Paul <abnominales@web.de>, linux-kernel@vger.kernel.org,
       davilla@4pi.com, nsankar@broadcom.com
Subject: Re: [patch staging] BCM70010 (crystalhd) Linux Driver
Message-ID: <20100103173417.GC9223@kroah.com>
References: <523138909@web.de> <20091231131852.GB32492@centrinvest.ru> <20100101001931.GA1290@kroah.com> <1a297b361001020805y6b00af83g81cf8492aa73bc3b@mail.gmail.com> <20100102163449.GB5172@kroah.com> <1a297b361001021017y746e4acdsfcf307b0f363e21d@mail.gmail.com> <9e4733911001021403n7ba076d0na423ae50e2983171@mail.gmail.com> <7cdf10991001022051k2c8454c1q5cffb955e901e58a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7cdf10991001022051k2c8454c1q5cffb955e901e58a@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 02, 2010 at 11:51:23PM -0500, Jarod Wilson wrote:
> > I'm not against this submission, but would it be better to wait until
> > Monday when the Broadcom authors are back as see if they want to
> > submit their own driver? That way changes would end up back in their
> > internal VCS.
> 
> Yes, please hold off a bit on this, I've actually been working on this
> driver with Scott and Naren (cc'd) for several months now (which is
> part of why it doesn't look so much like a lot of typical vendor code
> ;), and was planning to handle the submission on Naren and Broadcom's
> behalf. Just didn't expect someone else to hop on it this quickly. Was
> planning to get a git tree up on git.kernel.org over the weekend for
> both the driver and the lib, start prepping patches for review, etc.,
> but family time and home improvement projects have taken precedence
> the past few days (not to mention a few other driver projects that
> sucked up time earlier in the break, *cough* IR).

Ok, I'll ignore the patches from Manu for now, but please, do not create
a git tree, just send me what you have right now, as obviously some
people find it useful.  Then, everyone can work on it together in the
main kernel.org tree, like the rest of kernel development is done.

If you have any questions about how to do this, please let me know.

thanks,

greg k-h
