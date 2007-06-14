Return-Path: <linux-kernel-owner+w=401wt.eu-S1754820AbXFNH5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbXFNH5g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 03:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753040AbXFNH50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 03:57:26 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:59723 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979AbXFNH5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 03:57:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=jwiD/AGj7N6ZvCFYPGqAHtS0gT+Qv3pQQsJTM6Y2t94Huiv66lOin0Fdl1kZFy84t04Ukha1dqohX/VwkwB9m3BGngEj3abBHlDn5nWjqfsBbHXn/SnSgArsNw+te1FH2gzSjcEJQYKQ3oqJqIfexdPEIxRca9pprQRiGeFoQ1w=
From: Paulo Pereira <pfmp.404@gmail.com>
To: Greg KH <gregkh@suse.de>
Subject: Re: [2/2] 2.6.22-rc4: known regressions with patches v3
Date: Thu, 14 Jun 2007 08:57:14 +0100
User-Agent: KMail/1.9.6
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       linux-wireless@vger.kernel.org, Samuel Ortiz <samuel@sortiz.org>,
       Andrey Borzenkov <arvidjaar@mail.ru>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>, Ingo Molnar <mingo@elte.hu>,
       Alan Stern <stern@rowland.harvard.edu>
References: <46704B5D.5020106@googlemail.com> <46704C4D.5010803@googlemail.com> <20070613203501.GA5708@suse.de>
In-Reply-To: <20070613203501.GA5708@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706140857.14824.pfmp.404@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A Wednesday 13 June 2007 21:35:02, Greg KH escreveu:
> On Wed, Jun 13, 2007 at 09:58:05PM +0200, Michal Piotrowski wrote:
> >  USB
> >
> >  Subject    : list_add corruption. prev->next should be next (f7d28794),
> > but was f0df8ed4 (prev=f0df8ed4) Kernel Bug at lib/list_debug.c:33
> >  References : http://bugzilla.kernel.org/show_bug.cgi?id=8561
> >  Submitter  : Paulo Pereira <pfmp.404@gmail.com>
> >  Handled-By : Alan Stern <stern@rowland.harvard.edu>
> >  Patch      : http://bugzilla.kernel.org/show_bug.cgi?id=8561#c8
> >  Status     : patch was suggested
>
> I'm pretty sure this wasn't a "regression" and was always there, and
> that the proposed patch did fix the solution, right Paulo and Alan?
>
> thanks,
>
> greg k-h

	No I haven't fix the problem... I'am waiting for a friend that is in 
holiday's and work's with linux well. I'am beginer in linux and I can't put 
the patch to work, because of that I'am waiting for him to see if the patch 
work. 
	Sorry, the fact I don't say anything about the problem but my friend comes 
this week and them we put the patch and I will tell something!!
Regards, Paulo.
