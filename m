Return-Path: <linux-kernel-owner+w=401wt.eu-S1754461AbZHFIjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbZHFIjc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 04:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753706AbZHFIjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 04:39:32 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:61744 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506AbZHFIjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 04:39:31 -0400
X-Greylist: delayed 363 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Aug 2009 04:39:30 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ne8RLPg+535aJEUV31YANpWEs00JmfsigXgCwpxgOT5iyEQm3IXw4BkmEDZReb4ndu
         3x9L4quhlhfvWzAHU+AjWZt+jvtWBJXIHq6JHiJaUyIBMg5M1rlbDCPaKTnY9dA7ItAD
         z7mf0d6QAKuvEyBPNtVG2NpaGsAuziey6ries=
Date: Thu, 6 Aug 2009 10:32:19 +0200
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Valdis.Kletnieks@vt.edu
Subject: Re: perf: "Longum est iter per praecepta, breve et efficax per
	exempla"
Message-ID: <20090806083219.GA4163@Pilar.aei.mpg.de>
References: <1249409546-6343-1-git-send-email-mel@csn.ul.ie> <1249409546-6343-5-git-send-email-mel@csn.ul.ie> <20090804112246.4e6d0ab1.akpm@linux-foundation.org> <20090804195717.GA5998@elte.hu> <16246.1249484030@turing-police.cc.vt.edu> <20090805185334.GA4535@Pilar.aei.mpg.de> <84144f020908060008x34a320e2nc6a6bf8a665e51b4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020908060008x34a320e2nc6a6bf8a665e51b4@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pekka,

On Thu  6.Aug'09 at 10:08:44 +0300, Pekka Enberg wrote:
> Hi Carlos,
> 
> On Wed, Aug 5, 2009 at 9:53 PM, Carlos R. Mafra<crmafra2@gmail.com> wrote:
> > A few examples of how 'perf' can be used, from an e-mail by
> > Ingo Molnar http://lkml.org/lkml/2009/8/4/346.
> >
> > Signed-off-by: Carlos R. Mafra <crmafra2@gmail.com>
> > ---
> >
> > This "patch" is my way of _suggesting_ some "documentation by examples"
> > of what 'perf' can do to the guys who can really write it :-)
> 
> I was also looking for a perf "cookbook" and Ingo suggested we should
> put this stuff on the kernel.org wiki:
> 
> http://perf.wiki.kernel.org/index.php/Main_Page
> 
> How about just putting the email there?

First of all I just would like to rephrase my comment in the patch.

It was not meant to be a suggestion for Ingo to write more documentation
per se, it was my way of pointing out that such "documentation" is 
useful for beginners and that I, as Valdis, appreciated reading it.
So it was more of a "keep coming" and don't rephrain from writing these
examples in the e-mails kind of thing.

Now about the wiki. Yeah, that sounds great and I didn't know about it
yesterday. It will be nice if the wiki becomes a place where people
can look for such usage examples.

Thanks for the attention,
Carlos





