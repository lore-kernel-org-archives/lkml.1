Return-Path: <linux-kernel-owner+w=401wt.eu-S1758081AbXFSIsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758081AbXFSIsi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 04:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbXFSIsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 04:48:30 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:30404 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110AbXFSIs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 04:48:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=tsujKsTSpPVnDqZqLVMk8bVPdXEZuTFOmdf+mFRZmbH0O1CDBy5kWKDJjLdQ9avR374HnwvxGPh0qh7md+sVFvaBjsPWY9eCYh2uqN7KY0MNodeYvhfQRmBV8U59eWlxizdXP7SoefhhcxU199Wkyv/kiG27uH0+i14ixKni+xI=
From: Paulo Pereira <pfmp.404@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [2/2] 2.6.22-rc4: known regressions with patches v3
Date: Tue, 19 Jun 2007 09:48:27 +0100
User-Agent: KMail/1.9.6
Cc: Greg KH <gregkh@suse.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0706131659570.13726-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0706131659570.13726-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706190948.27710.pfmp.404@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A Wednesday 13 June 2007 22:01:54, Alan Stern escreveu:
> On Wed, 13 Jun 2007, Greg KH wrote:
> > On Wed, Jun 13, 2007 at 09:58:05PM +0200, Michal Piotrowski wrote:
> > >  USB
> > >
> > >  Subject    : list_add corruption. prev->next should be next
> > > (f7d28794), but was f0df8ed4 (prev=f0df8ed4) Kernel Bug at
> > > lib/list_debug.c:33 References :
> > > http://bugzilla.kernel.org/show_bug.cgi?id=8561
> > >  Submitter  : Paulo Pereira <pfmp.404@gmail.com>
> > >  Handled-By : Alan Stern <stern@rowland.harvard.edu>
> > >  Patch      : http://bugzilla.kernel.org/show_bug.cgi?id=8561#c8
> > >  Status     : patch was suggested
> >
> > I'm pretty sure this wasn't a "regression" and was always there, and
> > that the proposed patch did fix the solution, right Paulo and Alan?
>
> I'm also pretty sure that it's not a regression and that the patch
> should have fixed it.  But since Paolo hasn't replied to any of our
> queries, we can't be certain.
>
> Alan Stern

Hi, I'am writting for tell that the patch work well, I have Ktorrent working 
for 3 days and there is no Kernel Panic!!!! But I'am using Kernel 2.6.22-rc4 
with the patch that you send!!
Thank you, Paulo
