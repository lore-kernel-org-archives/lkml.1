Return-Path: <linux-kernel-owner+w=401wt.eu-S1757882AbXFTRfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757882AbXFTRfM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 13:35:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754523AbXFTRe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 13:34:59 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:61768 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110AbXFTRe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 13:34:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sEtl3j1LVvvgUkBw8N95ux+5yQh9NGj+N/KSJa+vlDgxWBiNDs6byds/na7VmQ97sRBBjaiwWNsPkCLY0HmrtAvQY64nUtVSc45UhWO6u9gQlOfuCzG/wbCeTO5ErD3cZNb30oIZ6YJ6/Hj7c+JbSMIxV0bg41/PNvIq8vRhcjg=
Message-ID: <9a8748490706201034j43139301w5a18c172d688c724@mail.gmail.com>
Date: Wed, 20 Jun 2007 19:34:57 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Alexandre Oliva" <aoliva@redhat.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Al Viro" <viro@ftp.linux.org.uk>,
       "Bernd Schmidt" <bernds_cb1@t-online.de>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Ingo Molnar" <mingo@elte.hu>,
       "Daniel Hazelton" <dhazelton@enter.net>, "Greg KH" <greg@kroah.com>,
       "debian developer" <debiandev@gmail.com>, david@lang.hm,
       "Tarkan Erimer" <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <orhcp4algt.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <or3b0qgy8r.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <alpine.LFD.0.98.0706171630150.14121@woody.linux-foundation.org>
	 <orlkeidryp.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <alpine.LFD.0.98.0706181104570.14121@woody.linux-foundation.org>
	 <ork5u1awtq.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <alpine.LFD.0.98.0706181232230.3593@woody.linux-foundation.org>
	 <or7iq1atex.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <alpine.LFD.0.98.0706181344080.3593@woody.linux-foundation.org>
	 <orhcp4algt.fsf@oliva.athome.lsd.ic.unicamp.br>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/06/07, Alexandre Oliva <aoliva@redhat.com> wrote:
> On Jun 18, 2007, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > In the GPLv3 world, we have already discussed in this thread how you can
> > follow the GPLv3 by making the TECHNICALLY INFERIOR choice of using a ROM
> > instead of using a flash device.
>
> Yes.  This is one option that doesn't bring any benefits to anyone.
> It maintains the status quo for users and the community, but it loses
> the ability for the vendor to upgrade, fix or otherwise control the
> users.  Bad for the vendor.
>
Also bad for the user since now the vendor can no longer supply
updated firmware to fix bugs or otherwise improve the device. Also,
the vendow has the problem that devices that get returned for repair
or similar can't easily be updated software wise. For the vendor not
to be able to update the box creates a lot of problems for both the
vendor and the end user.


> As another option, the vendor can respect users' freedoms, and then
> everybody wins big.  That's the option that anti-tivoization provides
> economic incentive for vendors to take.  Sure, they may still prefer
> the alternative above, or stick with an older version (which has its
> costs), or move to different software (which also has its costs), but
> it's unreasonable to claim that I'm advocating for vendors to move to
> ROM.
>
I am fairly confident that if too much software switches to GPLv3
we'll see a lot of businesses move to BSD or proprietary software.
That means *we* lose bigtime.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
