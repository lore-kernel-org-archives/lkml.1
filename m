Return-Path: <linux-kernel-owner+w=401wt.eu-S1030348AbXCSQ3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030348AbXCSQ3f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 12:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030346AbXCSQ3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 12:29:35 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:41750 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030348AbXCSQ3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 12:29:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Tg8JxajODbMv783l4UP6iyqkOJGLkC5BWozI2rbIIbEjosBQVXAILhV2sYxKVkC8HTKDVPaHhVfz3OQjxQpz8fYfIARUqCE11RP1q+TydJTl6TCCYJe1ov+q7L3ebhLdZzjiZWjxyuYMBDRw+dR2MzJ9j0Uh1nJT/d9ectwYdFk=
Message-ID: <6bffcb0e0703190929rd118b16u21552da0c81b9f04@mail.gmail.com>
Date: Mon, 19 Mar 2007 17:29:32 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Pekka J Enberg" <penberg@cs.helsinki.fi>
Subject: Re: mm snapshot broken-out-2007-03-18-02-44.tar.gz uploaded
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Alan Cox" <alan@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0703191751560.21196@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703180946.l2I9kTVc020636@shell0.pdx.osdl.net>
	 <45FD8684.4030501@googlemail.com>
	 <6bffcb0e0703190845s6bdc1a65p71937d1dffbf6d9e@mail.gmail.com>
	 <Pine.LNX.4.64.0703191751560.21196@sbz-30.cs.Helsinki.FI>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/03/07, Pekka J Enberg <penberg@cs.helsinki.fi> wrote:
> Hi Micael,
>
> On Mon, 19 Mar 2007, Michal Piotrowski wrote:
> > Pekka, can you take a look at this problem and fix my initrd? :)
> >
> > GOOD
> > #
> > revoke-special-mmap-handling.patch
> > revoke-core-code.patch
> > revoke-core-code-misc-fixes.patch
> > revoke-core-code-fix-shared-mapping-revoke.patch
> > revoke-core-code-move-magic.patch
> > revoke-support-for-ext2-and-ext3.patch
> > revoke-add-documentation.patch
> > revoke-wire-up-i386-system-calls.patch
> > BAD
>
> Oh, sorry about that. Can you confirm that the patch
> revoke-special-mmap-handling.patch is bad?

Yes, revoke-special-mmap-handling.patch is bad.

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
