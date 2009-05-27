Return-Path: <linux-kernel-owner+w=401wt.eu-S1761133AbZE0Xna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761133AbZE0Xna (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 19:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755611AbZE0XnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 19:43:22 -0400
Received: from mail.crca.org.au ([67.207.131.56]:39090 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755481AbZE0XnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 19:43:21 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
From: Nigel Cunningham <nigel@tuxonice.net>
Reply-To: nigel@tuxonice.net
To: Len Brown <lenb@kernel.org>
Cc: Ray Lee <ray-lk@madrabbit.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org,
       tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.0905271437530.4277@localhost.localdomain>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net>
	 <200905081611.41865.rjw@sisk.pl> <1241819569.19600.281.camel@nigel-laptop>
	 <200905090046.21282.rjw@sisk.pl> <1241825408.19600.384.camel@nigel-laptop>
	 <2c0942db0905081644l73a7a4f5i8af4677046797df@mail.gmail.com>
	 <alpine.LFD.2.00.0905271437530.4277@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 28 May 2009 09:43:45 +1000
Message-Id: <1243467825.13930.134.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len.

On Wed, 2009-05-27 at 15:10 -0400, Len Brown wrote:
> > Please stick at this.
> 
> I agree with Ray, and could not have said it better.
> 
> I will, however, reference prior art...
> 
> Greg KH said the exact same thing in 2005
> when he met with Nigel and Pavel in Ottawa.
> 
> >From Patrick Mochel's minutes, available here:
> http://lwn.net/Articles/144193/
> 
> "Suspend2 and Software Suspend
> 
> There was agreement among the attendees that Nigel Cunningham's 
> suspend-to-disk patches ("Suspend2") are stable and worthwhile to many 
> users. It was suggested that he begin the process of merging his patches 
> with Pavel Machek's in-kernel software suspend implementation. A lengthy 
> discussion followed about strategies for doing so and the philosophy of 
> gradual kernel development.
> 
> To briefly recap: Suspend2 is very robust and feature rich. Not only does 
> it include a reliable process freezer, it has the ability to compress and 
> encrypt the suspended image and includes a graphical status bar. Although 
> it apparently does receive positive reviews from users, most kernel 
> developers do not care about such eye candy. It was suggested and agreed 
> that Nigel will split the patches (all 69 of them so far) into functional 
> groups, and push them separately. We agreed that the process freezer 
> patches would come first, which should also benefit the existing suspend 
> implementation as well. Next will most likely be the new algorithmic core 
> and eventually the plugin architecture and graphical features. It was 
> heavily stressed that Nigel and Pavel must work together and that the more 
> effort that is put in to making the patches smaller and simpler, the 
> easier it will be to merge this work. "
> 
> While "suspend2" is now called "tux-on-ice", the same message
> about how to merge upstream applies in 2009
> just as much as it did in 2005.
> 
> Rafael's reference to ch10 in HPA's articulate 2008 OLS paper is apt
> http://ols.fedoraproject.org/OLS/Reprints-2008/anvin-reprint.pdf
> The involved parties must have common motivation to make forward progress.
> 
> The process should be to cherry-pick the out-of-tree implementation
> to gradually improve the in-tree-implementation.  If we had started
> that 4 years ago, we'd be done by now.  If we don't start it now,
> we'll be having this same conversation again in 2013.

Thanks for the encouragement.

I'm seeking to do this with Rafael, and he's being really good to deal
with.

Regards,

Nigel

