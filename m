Return-Path: <linux-kernel-owner+w=401wt.eu-S1760215AbYFQXsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760215AbYFQXsY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 19:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbYFQXsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 19:48:16 -0400
Received: from web52512.mail.re2.yahoo.com ([206.190.48.195]:20709 "HELO
	web52512.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751828AbYFQXsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 19:48:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=OWFhA3+ELBmibGP27WRRoXHVll8zF51ebRs3gHpxUgeGw5DjgHzOC37SzW3L4aP6UmT9H79PleuvbVQPFBw7fRf+/XyhXGLalo5e6oz89ktU9Uw0i64I6uctIGqU73cIPlhPfH5MK9RSZIqXMf4n8I436/HCmlFIAEFvqKkSZ6w=;
X-Mailer: YahooMailWebService/0.7.199
Date: Tue, 17 Jun 2008 16:48:14 -0700 (PDT)
From: Marc Perkel <mperkel@yahoo.com>
Reply-To: mperkel@yahoo.com
Subject: Re: AMD Dual Core vs. Quad - Power Management
To: David Rees <drees76@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <72dbd3150806171626q1b8ebf54g931424b8deec5e7a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <679566.97158.qm@web52512.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Marc Perkel
Junk Email Filter dot com
http://www.junkemailfilter.com


--- On Tue, 6/17/08, David Rees <drees76@gmail.com> wrote:

> From: David Rees <drees76@gmail.com>
> Subject: Re: AMD Dual Core vs. Quad - Power Management
> To: mperkel@yahoo.com
> Cc: linux-kernel@vger.kernel.org
> Date: Tuesday, June 17, 2008, 4:26 PM
> On Tue, Jun 17, 2008 at 3:00 PM, Marc Perkel
> <mperkel@yahoo.com> wrote:
> > Been running a few tests and an AMD motherboard
> booting 2.6.25 from
> > flash uses 0.33 amps if the CPU is a AM2 Athlon 6000.
> But if I used a
> >  Phenom Quad core CPU 9550 it pulls 0.55 amps.
> >
> > In theory the 9550 should pull less because it's a
> lower TPD and the
> > phenom processor is supposed to be smarter about power
> management.
> >
> > So - why is the Phenom pulling more power? Is it
> because power
> > management software for the Phenom isn't updated
> yet?
> 
> At idle with CoolNQuiet on, all AMD processors seem to pull
> close to
> the same amount of power, varying between 7-11 watts.
> Except for the
> quad core processors, which pull significantly more at idle
> w/CnQ on
> than dual and single core processors.
> 
> Tom's hardware has a nice chart listing power
> consumption here, all
> his testing was done under Windows. His tests show the
> Phenom pulling
> about twice the power of the Athlon64 X2 6000+ which
> matches up pretty
> closely to your numbers.
> 
> http://www.tomshardware.com/reviews/amd-power-cpu,1925-7.html
> 
> Sounds like a question for AMD. The Phenoms seem to be
> pretty good
> except for the extra 10-11w of power draw at idle which is
> disappointing.
> 
> -Dave

Thanks - that definitely answered my question. And I'm using b3 stepping.



      
