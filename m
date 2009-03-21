Return-Path: <linux-kernel-owner+w=401wt.eu-S1753871AbZCUFaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871AbZCUFaY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 01:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751817AbZCUFaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 01:30:08 -0400
Received: from kroah.org ([198.145.64.141]:57732 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751572AbZCUFaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 01:30:07 -0400
Date: Fri, 20 Mar 2009 22:28:41 -0700
From: Greg KH <greg@kroah.com>
To: Shilp Dixit <shilp.dixit@gmail.com>
Cc: Till Kamppeter <till.kamppeter@gmail.com>, jbottomley@novell.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, tech-board@lists.linux-foundation.org
Subject: Re: [Tech-board] Project idea for the Google Summer of Code 2009
Message-ID: <20090321052840.GA16361@kroah.com>
References: <49C402A2.1040705@gmail.com> <20090320213128.GB12078@kroah.com> <c1369cb90903202145n76cec291x29bb6b5477b52007@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1369cb90903202145n76cec291x29bb6b5477b52007@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 21, 2009 at 10:15:48AM +0530, Shilp Dixit wrote:
> Hi
> 
> Ya i agree the concept might be pretty similar to the open suse built
> packages but aren't most of these services either online or not very
> flexible...What I was suggesting is to make a tool that is available on
> every linux OS as an update or something...They give the user more
> personalisation power and also allows non-tech users to create their own
> live CD's or USB devices... The front end(GUI) will provide 'drag and drop'
> facility for the different packages and will make life much easier in terms
> of making individual flavours...

Ok, that's fair enough, but I fail to see how this relates to the kernel
itself.  It looks like it's just a tool to package things up in some
way, no kernel changes would be needed, right?

thanks,

greg k-h
