Return-Path: <linux-kernel-owner+w=401wt.eu-S1760217AbXEMTKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760217AbXEMTKe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 15:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758475AbXEMTKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 15:10:12 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:45640 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758288AbXEMTKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 15:10:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mlMcR61Zjxr1w4MCwPECviKDcPoD6XDZTxFi4twoDJcGq0gnaeBOeKmwLx9zrjv0vrUa9cP3g8mPb2BSocKAilmnVGenQyi39+JbLmZqVlFAZXw1/KXHzJ3tsZNShx0VpFxFj+RhdHr3wo0KEM4sVByCrn8PH4o4mkw3HJc90Y8=
Message-ID: <6bffcb0e0705131210p3c0ea948if3c89e9e275e1470@mail.gmail.com>
Date: Sun, 13 May 2007 21:10:09 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Re: [1/2] 2.6.22-rc1: known regressions
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Charles Gagalac" <charle97@yahoo.com>
In-Reply-To: <Pine.LNX.4.64.0705131159240.3212@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46475595.4050105@googlemail.com>
	 <Pine.LNX.4.64.0705131118160.3212@alien.or.mcafeemobile.com>
	 <6bffcb0e0705131152y2c2035a1rf609ef818e847bb6@mail.gmail.com>
	 <Pine.LNX.4.64.0705131159240.3212@alien.or.mcafeemobile.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/05/07, Davide Libenzi <davidel@xmailserver.org> wrote:
> [Cc trimmed]
>
> On Sun, 13 May 2007, Michal Piotrowski wrote:
>
> > On 13/05/07, Davide Libenzi <davidel@xmailserver.org> wrote:
> > > On Sun, 13 May 2007, Michal Piotrowski wrote:
> > >
> > > > Subject    : applications under wine freezes
> > > > References : http://bugzilla.kernel.org/show_bug.cgi?id=8462
> > > > Submitter  : Charles Gagalac <charle97@yahoo.com>
> > > > Caused-By  : Davide Libenzi <davidel@xmailserver.org>
> > > >              commit 6192bd536f96c6a0d969081bc71ae24f9319bfdc
> > > > Handled-By : Davide Libenzi <davidel@xmailserver.org>
> > > > Status     : problem is being debugged
> > >
> > > This has been fixed. Confirmed by myself and Charles Gagalac. Patches have
> > > been sent to Andrew.
> >
> > Bugzilla is back. Did you mean this patch
> > http://bugzilla.kernel.org/show_bug.cgi?id=8462#c8 ?
>
> That one does not apply on the latest mainline, and comments are
> broken. There are two new patches posted on lkml:
>
> http://lkml.org/lkml/2007/5/11/412
> http://lkml.org/lkml/2007/5/11/413

Thanks, informations updated.

>
>
>
> - Davide
>
>
>

Regards,
Michal

-- 
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
