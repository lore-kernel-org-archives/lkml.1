Return-Path: <linux-kernel-owner+w=401wt.eu-S937998AbXGSTTG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937998AbXGSTTG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 15:19:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765243AbXGSTSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 15:18:46 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:40062 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765754AbXGSTSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 15:18:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=g8UAp9fzsfqriypwW1ogQHJnn5EBOpblKtmAifCUsznWs1v9R15hV93Y+uaHmxFUOIlpzEt7TodwDD0nR9e+7xC+21U97IDNR0J5Bb7QiJ48WyflgmDHnQEasJ5oGIBiFdjQ8aik/EYfeMqhR9USzOSSLh1qg0NHtNOspryWwII=
Message-ID: <6bffcb0e0707191218j7ecc0fa4re2a2ae7c82c95668@mail.gmail.com>
Date: Thu, 19 Jul 2007 21:18:43 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
Subject: Re: [2/2] 2.6.22-git: known regressions
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       "Kumar Gala" <galak@kernel.crashing.org>, linuxppc-dev@ozlabs.org
In-Reply-To: <200707192127.07238.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <469F9125.8040502@googlemail.com> <469F92AF.10405@googlemail.com>
	 <200707192127.07238.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/07/07, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> On Thursday 19 July 2007, Michal Piotrowski wrote:
>
> > IDE
> >
> > Subject         : compile error if CONFIG_BLOCK not enabled related to linux/ide.h include
> > References      : http://lkml.org/lkml/2007/7/18/11
> > Last known good : ?
> > Submitter       : Kumar Gala <galak@kernel.crashing.org>
> > Caused-By       : ?
> > Handled-By      : Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Status          : unknown
>
> Not a 2.6.22-git regression (CONFIG_BLOCK was added on September 2006) and
> Kumar should have a fix really soon - could be removed from the list IMO.

Ok, I removed it.

>
> Thanks,
> Bart
>

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
