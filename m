Return-Path: <linux-kernel-owner+w=401wt.eu-S1754877AbXFNUYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbXFNUYa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 16:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbXFNUYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 16:24:22 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:17927 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbXFNUYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 16:24:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=nWb4cj4z2/cpxfi9JdfjCiYRWq0MrJwDZmKKli1Rt7LA+k5nsPJx196rGepY37jSoxXRr+29Yc+vR3ZKtxOywdnGWqJokxha3nctSTGQWdq4cXdnCRUR0M9+h2WlWIxlbrrLDAkw4g3sUP5MsypV5KRstTfM0Q2Q0HKLCExuylU=
Message-ID: <161717d50706141324y303f3d89n54447b7cb387979c@mail.gmail.com>
Date: Thu, 14 Jun 2007 16:24:19 -0400
From: "Dave Neuer" <mr.fred.smoothie@pobox.com>
To: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Cc: "Alexandre Oliva" <aoliva@redhat.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Greg KH" <greg@kroah.com>, "debian developer" <debiandev@gmail.com>,
       "david@lang.hm" <david@lang.hm>, "Tarkan Erimer" <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>, mingo@elte.hu
In-Reply-To: <20070614175305.GI10008@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0706100301520.6675@asgard.lang.hm>
	 <20070610160531.GA12179@kroah.com>
	 <f24d23310706121107y2ef218a4wc1c8f9a52fc9bdd7@mail.gmail.com>
	 <20070612184110.GB7980@kroah.com>
	 <orir9smp3u.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <alpine.LFD.0.98.0706131223051.14121@woody.linux-foundation.org>
	 <or7iq7mx7f.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <20070613211432.GH10008@csclub.uwaterloo.ca>
	 <orodjjlbu1.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <20070614175305.GI10008@csclub.uwaterloo.ca>
X-Google-Sender-Auth: d98ec5062357dc29
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/14/07, Lennart Sorensen <lsorense@csclub.uwaterloo.ca> wrote:
> Nothing prevents you from taking tivos kernel
> changes and building your own hardware to run that code on, and as such
> the spirit of the GPL v2 seems fulfilled.

Oh, come on: you're not serious, right? Something indeed prevents me
-- the fact that I'm not a hardware manufacturer, I don't have fabs,
outsource vendors to provide me w/ designs, ASICs, etc. Nor to I have
the money to pay one-off prices for various components if they're even
available in batches that small.

This argument seems totally disingenuous to me. The GPLv<3 was written
in a time when the majority of sotware to which the license was
applied was written for general purpose computers. The "user" was the
owner of the computer, and Freedom 0 was about letting that user RUN
modified copies of the software.

Things have changed a lot; we're surrounded by embedded computers, and
Freedom 0 seems to strongly imply I should have the right to run
modified versions of the Free Software I own on the hardware I OWN. Or
is the future of Open Source that you'll be able to hack on free
software as long as you work for Intel, Red Hat, TiVO, Google or OSDL?
Or own many-thousand-$$ fab printer?

Look, I totally respect Linus' and others' position that the license
is an inappropriate way to enforce what they feel are hardware design
decisions, but can we dispense w/ the silly argument that the intent
of the GPL is fullfilled as long as the user is allowed to modify the
software where modify means "imagine a world where they'd be able to
run" it?

Dave
