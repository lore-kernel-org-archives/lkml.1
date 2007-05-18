Return-Path: <linux-kernel-owner+w=401wt.eu-S1757291AbXERIKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291AbXERIKX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 04:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754854AbXERIKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 04:10:08 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:39706 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745AbXERIKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 04:10:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=I7ttNR322XVXVl3gGlLNuFiAh0ABufl2qRUtmnq9hIxbAFE41Fozjyh/pLwRDTGmIdemTOEyUNVlIINcF7mDNTUrldS0hwmWlvWn1sKi45ikYmExXQMtmBA1e8b/WriDdF8+EGGATNXxqfUzenZy5/CbnI5+cPcmZqVLkKwHGGw=
Message-ID: <2cf1ee820705180110y740de989ma48553d4b2188845@mail.gmail.com>
Date: Fri, 18 May 2007 11:10:05 +0300
From: "emin ak" <eminak71@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: v2.6.21-rt3
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
In-Reply-To: <1179474804.12981.57.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070517194143.GA25394@elte.hu>
	 <2cf1ee820705180039l1d72005fq2169f8fa36e12377@mail.gmail.com>
	 <1179474804.12981.57.camel@chaos>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, 2.6.21 was compiled and boot successfully for ppc, Is 85xx family
supported for powerpc arch?
Thanks.

2007/5/18, Thomas Gleixner <tglx@linutronix.de>:
> On Fri, 2007-05-18 at 10:39 +0300, emin ak wrote:
> > Hi,
> > I have tried to compile -rt3 patch for ppc (mpc8540ads) and it failed
> > with undefined referance errors on ppc/kernel/asm-offsets.c. Here is
> > the compiler outputs:
>
> arch/ppc is known to be broken. Does it even compile on 2.6.21 vanilla ?
>
>         tglx
>
>
>
