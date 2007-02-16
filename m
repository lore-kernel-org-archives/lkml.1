Return-Path: <linux-kernel-owner+w=401wt.eu-S932310AbXBPNcD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310AbXBPNcD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 08:32:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932313AbXBPNcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 08:32:03 -0500
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:54475 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932310AbXBPNcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 08:32:01 -0500
Date: Fri, 16 Feb 2007 08:32:00 -0500
To: v j <vj.linux@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: GPL vs non-GPL device drivers
Message-ID: <20070216133200.GP7584@csclub.uwaterloo.ca>
References: <9b3a62ab0702142115m4ea7d2c0m6869eb64ef3ee14e@mail.gmail.com> <9b3a62ab0702142116n4069e16cl1bc8f546f41d935@mail.gmail.com> <1171524970.12771.568.camel@laptopd505.fenrus.org> <9b3a62ab0702150004n78763d4ei652b41c7edcd0755@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b3a62ab0702150004n78763d4ei652b41c7edcd0755@mail.gmail.com>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 12:04:26AM -0800, v j wrote:
> Ok so are thousands of others who are using Linux as their OS of
> choice in embedded systems. They are not doing this because they are
> eager to give back back. They are doing it because Linux provides
> compelling reasons for them to choose it. They could have very well
> chosen VxWorks or OSE too. They chose not to, but not because they
> were unwilling to be a parasite.

Some people in the embedded world actually think having access to
cooporating with thousands of other developers is a good thing.  I like
being able to ask questions and get feedback.  I have contributed back
some of my improvements, and the things I haven't are things I think
would make the kernel's drivers worse for general case use (due to
having a few bits of weirdness in our hardware), but anyone that wants
the source with those changes can have it.  Our older products which are
running a closed source OS (well as far as the customers are concerned
at least, since we have source and they don't) are eventually intended
to move to linux as well.  The support for the proprietary embedded OSs
have in our experience been pathetic.  Even when sent patches to fix
bugs they don't make it in to the next release in many cases.  No
thanks.  What keeps customers buying our products is that when there is
a problem we fix it as quickly as we can using whatever resources it
takes.  It isn't really in having secret source code for some feature.
It would be hard for a smallish company to come up with something so
amazing that a larger company couldn't reimplement the same thing in a
very short time if they thought it was useful.

--
Len Sorensen
