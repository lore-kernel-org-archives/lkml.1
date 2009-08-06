Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554AbZHFIkE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbZHFIkE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 04:40:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754421AbZHFIkD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 04:40:03 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:61744 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706AbZHFIkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 04:40:01 -0400
X-Greylist: delayed 363 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Aug 2009 04:39:30 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DqfCn6/6PLGR2DhMBI52Cw0dFJLvGS7qnJMsCALGx8lNxn/WHvuRc9c2hLMO56dm3J
         tfY5+fa1b/OQ5JKaOEWePVhCWQuWeVgdzBwR9Git4S7PJ98u2Zqp0F/VeJT+4/2MxTur
         9b/gpfzZ4HPc21Sqw3B4tlqGmFhmyXIbVAHuY=
Date: Thu, 6 Aug 2009 10:38:54 +0200
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Valdis.Kletnieks@vt.edu,
       =?utf-8?B?RnLDqWTDqXJpYw==?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: perf: "Longum est iter per praecepta, breve et efficax per
	exempla"
Message-ID: <20090806083854.GA4352@Pilar.aei.mpg.de>
References: <1249409546-6343-1-git-send-email-mel@csn.ul.ie> <1249409546-6343-5-git-send-email-mel@csn.ul.ie> <20090804112246.4e6d0ab1.akpm@linux-foundation.org> <20090804195717.GA5998@elte.hu> <16246.1249484030@turing-police.cc.vt.edu> <20090805185334.GA4535@Pilar.aei.mpg.de> <84144f020908060008x34a320e2nc6a6bf8a665e51b4@mail.gmail.com> <20090806073553.GA32074@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090806073553.GA32074@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu  6.Aug'09 at  9:35:53 +0200, Ingo Molnar wrote:
> 
> * Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> 
> > Hi Carlos,
> > 
> > On Wed, Aug 5, 2009 at 9:53 PM, Carlos R. Mafra<crmafra2@gmail.com> wrote:
> > > A few examples of how 'perf' can be used, from an e-mail by
> > > Ingo Molnar http://lkml.org/lkml/2009/8/4/346.
> > >
> > > Signed-off-by: Carlos R. Mafra <crmafra2@gmail.com>
> > > ---
> > >
> > > This "patch" is my way of _suggesting_ some "documentation by examples"
> > > of what 'perf' can do to the guys who can really write it :-)
> > 
> > I was also looking for a perf "cookbook" and Ingo suggested we should
> > put this stuff on the kernel.org wiki:
> > 
> > http://perf.wiki.kernel.org/index.php/Main_Page
> > 
> > How about just putting the email there?
> 
> Would be excellent. Carlos, do you have time to format those 
> examples over into the wiki and send a patch with an URL to the 
> wiki?

Yes, I can do that. In fact I just created an account in the wiki
and will put the examples there.
