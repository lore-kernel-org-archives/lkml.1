Return-Path: <linux-kernel-owner+w=401wt.eu-S936039AbXHMSgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936039AbXHMSgT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 14:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S943868AbXHMSN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 14:13:26 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:11868 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S945798AbXHMSNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 14:13:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NrBOISUzFW3wDAsrHeH/Ff+rXmUl5HsB30AoEQ7/4jsmMKg136vwz349cz5+P6A6iCcqedt3oux5/V/TFgy4JkhFCRAb7LnftSN56fc+pnO9b+bhLLQ3n3ALG/Jo/JIfWeVMrIRwJMqEyZGXpuKzmv9/nHZsrL/6IZdKrtMQ2Eg=
Message-ID: <6bffcb0e0708131113h72bbeb91v5c6fcd82af522b2a@mail.gmail.com>
Date: Mon, 13 Aug 2007 20:13:21 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Trond Myklebust" <Trond.Myklebust@netapp.com>
Subject: Re: [1/2] 2.6.23-rc3: known regressions with patches
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       "Jeff Garzik" <jeff@garzik.org>
In-Reply-To: <1187028281.6628.46.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46C09C1A.7050706@googlemail.com>
	 <1187028281.6628.46.camel@heimdal.trondhjem.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/08/07, Trond Myklebust <Trond.Myklebust@netapp.com> wrote:
> On Mon, 2007-08-13 at 19:59 +0200, Michal Piotrowski wrote:
>
> > FS
> >
> > Subject         : NFSv4 poops itself
> > References      : http://lkml.org/lkml/2007/7/27/144
> > Last known good : ?
> > Submitter       : Jeff Garzik <jeff@garzik.org>
> > Caused-By       : ?
> > Handled-By      : Trond Myklebust <Trond.Myklebust@netapp.com>
> > Patch           : http://lkml.org/lkml/2007/7/27/183
> > Status          : patch available
>
> A fix for this was merged by Linus prior to the release of 2.6.23-rc3.

commit b247bbf1da69ce376aa1ceb8057331214589e366
I overlooked it.

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
