Return-Path: <linux-kernel-owner+w=401wt.eu-S1759244AbXGXV5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759244AbXGXV5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 17:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540AbXGXV5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 17:57:23 -0400
Received: from qb-out-0506.google.com ([72.14.204.237]:58066 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755899AbXGXV5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 17:57:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=i8fZOQVW2PcmeLwAw83gFiRQViwgPVEai5zEVU/HiYjSi+RWjcnLYH5UIXXFaAoP3+m2OwFmYTXk25pszUd82sEDOBNsSxGBP57fVMoWd/wYnvzFs9Oosx0ZfKL1zst7lQ+dxdBFwDamvmZsppwf+n847p8wriLP71Oum/E8VDk=
Message-ID: <6bffcb0e0707241457m1a5f30a7w98470e0ad98ebdb8@mail.gmail.com>
Date: Tue, 24 Jul 2007 23:57:20 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: 2.6.23-rc1: known regressions with patches
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Gabriel C" <nix.or.die@googlemail.com>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       "Satyam Sharma" <satyam.sharma@gmail.com>,
       "Tejun Heo" <htejun@gmail.com>, "Kay Sievers" <kay.sievers@gmail.com>,
       "Cornelia Huck" <cornelia.huck@de.ibm.com>,
       "Vitaly Bordug" <vitb@kernel.crashing.org>,
       "Takashi Iwai" <tiwai@suse.de>, "Ingo Molnar" <mingo@elte.hu>,
       linux-fsdevel@vger.kernel.org, "Doug Chapman" <doug.chapman@hp.com>,
       "Vasily Tarasov" <vtaras@openvz.org>,
       "Thierry MERLE" <thierry.merle@free.fr>, v4l-dvb-maintainer@linuxtv.org,
       "Dwaine P. Garden" <dwainegarden@rogers.com>,
       "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       "Adrian Bunk" <bunk@stusta.de>
In-Reply-To: <20070723225924.GC25741@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46A47940.7030801@googlemail.com> <20070723225924.GC25741@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/07/07, Greg KH <gregkh@suse.de> wrote:
> On Mon, Jul 23, 2007 at 11:47:44AM +0200, Michal Piotrowski wrote:
> > Unclassified
> >
> > Subject         : kobject link failure
> > References      : http://lkml.org/lkml/2007/7/19/495
> > Last known good : ?
>
> This is caused by a patch that happened after 2.6.22 was released, so it
> is a regression.

Yes, I know. "?" is a default value. When someone says that bug
appeared after 2.6.22-git7 I'm adding this information to "Last known
good".

>
> > Submitter       : Jan Engelhardt <jengelh@linux01.gwdg.de>
> > Caused-By       : ?
> > Handled-By      : Cornelia Huck <cornelia.huck@de.ibm.com>
> >                   Greg Kroah-Hartman <gregkh@suse.de>
> > Patch           : http://lkml.org/lkml/2007/7/20/143
> > Status          : patch available
>
> I'll be sending Cornelia's patch to Linus within the week to fix this.
>
> thanks,
>
> greg k-h
>

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
