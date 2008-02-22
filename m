Return-Path: <linux-kernel-owner+w=401wt.eu-S1760661AbYBVU0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760661AbYBVU0q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 15:26:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbYBVU0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 15:26:34 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:47898 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbYBVU0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 15:26:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HaRMZsx3avqDdbiTMNQBrztRMg4nKeiacfeEMcXHP8fZtmVo3khHUl6rDCkWoTXXre7OOBYpaBhqn6W2lkFGlRzQZLxVrV7A0VqtQ0fjsii68G/zqvdhWSUfQtGpX7cbtahFGbajV7BzKkms3RG9fagcx8yFnLH7eez+6exy8Zs=
Message-ID: <6101e8c40802221226t3097a97fjc75fd64e05a708e3@mail.gmail.com>
Date: Fri, 22 Feb 2008 21:26:31 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [stable] [2.6.22.y] {13/14} - NFSv2/v3: Fix a memory leak when using -onolock - on top of 2.6.22.17
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org
In-Reply-To: <20080222201413.GA12330@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6101e8c40802071203o1b32c2c2md53859623228463@mail.gmail.com>
	 <20080222201413.GA12330@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/22/08, Greg KH <greg@kroah.com> wrote:
> On Thu, Feb 07, 2008 at 09:03:52PM +0100, Oliver Pinter wrote:
> > aka: nfs-unmount-leak.patch
> >
> > From: Trond Myklebust <Trond.Myklebust@netapp.com>
> > Date: Tue Dec 11 11:05:19 2007 -0500
> > Subject: NFSv2/v3: Fix a memory leak when using -onolock
> > Patch-mainline: 2.6.24
> > References: 336253
> >
> > mainline: 13ef7b69b54aa8ae4ed264d0bf41339737f8543a
>
> No, that's the wrong commit id. Please be more careful next time, it's
> no fun having to verify every id to make sure that I can trust these
> patches...

sorry, my bad, im future checked i it several time

>
> It's 5cef338b30c110daf547fb13d99f0c77f2a79fbc just for future reference.
>
> thanks,
>
> greg k-h
>
--
Thanks,
Oliver
