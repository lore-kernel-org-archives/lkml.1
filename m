Return-Path: <linux-kernel-owner+w=401wt.eu-S1758286AbYFXLlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758286AbYFXLlY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 07:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752578AbYFXLlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 07:41:16 -0400
Received: from bx178.blacksun.ca ([69.27.117.8]:33194 "EHLO bx178.blacksun.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752136AbYFXLlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 07:41:15 -0400
Date: Tue, 24 Jun 2008 07:33:47 -0400
From: Greg Louis <glouis@dynamicro.ca>
To: linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Position Statement on Linux Kernel Modules
Message-ID: <20080624113347.GA5246@hp0.dynamicro.ca>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20080623050118.GA22852@kroah.com> <20080623112934.GC5713@hp0.dynamicro.ca> <20080623130917.GB1369@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20080623130917.GB1369@1wt.eu>
Organization: Dynamicro Consulting Limited
X-yoursite-MailScanner-Information: Please contact the ISP for more information
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: glouis@dynamicro.ca
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:

> > (Of course, the best way to rebut that argument [ that outside the
> > developer community, nobody cares whether drivers are proprietary ]
> > would be for end-users to vote with their feet, but for a lot of
> > us, me included, that's not a practical option.)
> 
> The problem is exactly what you describe in your last sentence. Hardware
> manufacturers are well aware of that and make no effort to provide correct
> drivers when they (think they) have a monopoly in certain areas.
> 
> What would be needed would be a public list of alternative hardware for
> known existing hardware.
...
> Willy

That is Utopian, I fear.  For example, what notebook supports the
installation of alternative hardware?  Go to another notebook, you
suggest?  Easy said: when I was buying the machine on which this is
being written, the choice of notebooks with 1920x1200 displays (a sine
qua non as far as I was concerned) was _extremely_ limited.  (There
actually was an open-source driver for the video of the one I picked,
but I could never get it to work.)  Similar difficulties exist for a
lot of special-purpose hardware; viable alternatives are rare.  Your
proposed list could certainly help ferret out such rarities, but I
doubt that it would suffice to make the problem go away.  I suspect,
too, that it would be a beast to maintain, given the need to track all
the features of all the versions of all the hardware items that were
listed.

Then again, my proposed list (a parallel to Greg KH's developer list,
but for end-users) probably wouldn't suffice either.  But it would be
relatively easy to create, and if it got big enough, and if some
manufacturers were hesitating about going open-source, it might tip a
scale or two.

In another message on this list, Greg KH says he has no objection to my
proposal but doesn't want to do it himself (a reasonable position given
the workload he's carrying already).  I'll try to set something up and
will ANNOUNCE it here if I succeed.

-- 
| G r e g  L o u i s         | gpg public key:         0x6D9E3E64 |
|  http://www.bgl.nu/~glouis |   (on my website or any keyserver) |
