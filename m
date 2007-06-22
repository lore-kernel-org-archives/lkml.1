Return-Path: <linux-kernel-owner+w=401wt.eu-S1754131AbXFVMOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbXFVMOT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 08:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbXFVMOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 08:14:04 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:61354 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbXFVMOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 08:14:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=R+I5mdVp3XY7VDcLJv4U/tFE5kMqcxdMPJ7fqLqbDeSHeTfDJoFhic244kChWP3/fnAFxSFYk/IHnKFNfP4eiGBFIlcOz1Y/38KgB/dO8L2qfWOiyYK6J8cLmaGHL4JziFQ4/S+I0SnnSV6P0v3oylUg73mNDfNOCMO1pg0Wyu8=
Message-ID: <6bffcb0e0706220513n50740fedrce56467f72718dcd@mail.gmail.com>
Date: Fri, 22 Jun 2007 14:13:59 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [1/2] 2.6.22-rc5: known regressions with patches v2
Cc: "Ni@m" <niam.niam@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070622125428.28934ee0@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <467AA8CA.2020206@googlemail.com>
	 <a9e22dff0706220259y6b2cec29s8f5e059ba8c42b77@mail.gmail.com>
	 <6bffcb0e0706220427p203de10epeaa6e97d3f63886d@mail.gmail.com>
	 <a9e22dff0706220439m4bc70a30i8cc83fe92cff8bc9@mail.gmail.com>
	 <20070622125428.28934ee0@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/06/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Fri, 22 Jun 2007 14:39:50 +0300
> "Ni@m" <niam.niam@gmail.com> wrote:
>
> > > We have patches for "very high non-preempt latency in
> > > context_struct_compute_av()" and "list_add corruption. prev->next
> > > should be next (f7d28794), but was f0df8ed4 (prev=f0df8ed4) Kernel Bug
> > > at lib/list_debug.c:33", but both are too intrusive.
> > >
> > > Anyway, those bugs are not regressions.
> > The question was "why linux kernel release should have some bugs that
> > would be fixed fixed in future?"
>
> Because those bug fixes are intrusive so will potentially cause more
> other bugs that will need fixing - so make the kernel a worse not a
> better one in the short term.
>
> > Let's wait and publish kernel w/o known bugs.
>
> That would be a bit like waiting for a Debian release and never happen.

I'm trying to imagine this - Linux 2.6 "Debian style" roadmap:
15-VII-2007 - release of Linux 2.6.22
1-VIII-2007 - freeze
15-II-2009 - release of Linux 2.6.23
1-III-2009 - freeze
1-IX-2010 - release of Linux 2.6.24

:)

>
> Alan
>

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
