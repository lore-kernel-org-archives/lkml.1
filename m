Return-Path: <linux-kernel-owner+w=401wt.eu-S1753948AbZEKDM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbZEKDM1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 23:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbZEKDMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 23:12:17 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:52123 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbZEKDMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 23:12:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iyl9lBFAIRfMh5zOsuw8rGIp05gm2WaFSu4t9/3mgxdWsoY08XVJtGTMOTRw/hX2ff
         FX0uzOU2bh/mDfQ28we+6sw5BzRwHTx+DOUUaVrPiq9ZM0KvZ6YDNmdT1RPYnlVbSdii
         9j2k9UoiLfAHMgpRf1ggi+dsfcEYlULfgQX90=
Date: Sun, 10 May 2009 20:12:09 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Kim Kyuwon <chammoru@gmail.com>
Cc: Trilok Soni <soni.trilok@gmail.com>, Kim Kyuwon <q1.kim@samsung.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] Input: add MAX7359 key switch controller driver, v2
Message-ID: <20090511031208.GA15208@dtor-d630.eng.vmware.com>
References: <4A04E5EA.7000103@samsung.com> <5d5443650905091027w2b60f2ael520373790e6414c7@mail.gmail.com> <4d34a0a70905101934j320c03abl7e39af4fbfdf1f62@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d34a0a70905101934j320c03abl7e39af4fbfdf1f62@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 11:34:54AM +0900, Kim Kyuwon wrote:
> Hi Trilok,
> 
> On Sun, May 10, 2009 at 2:27 AM, Trilok Soni <soni.trilok@gmail.com> wrote:
> > Hi Kim,
> >
> > On Sat, May 9, 2009 at 7:39 AM, Kim Kyuwon <q1.kim@samsung.com> wrote:
> >> The Maxim MAX7359 is a I2C interfaced key switch controller which provides
> >> microprocessors with management of up to 64 key switches.
> >> This patch adds support for the MAX7359 key switch controller.
> >>
> >> Signed-off-by: Kim Kyuwon <q1.kim@samsung.com>
> >
> >
> > Thanks for implementing review comments. Please add
> >
> > Reviewed-by: Trilok Soni <soni.trilok@gmail.com>
> 
> Sorry, I didn't know I should put the "Reviewed-by" in the reviewed
> patch.(I'm still kernelnewbie :) )

You are not supposed to add it until somebody explicitely asks you to
do that, same with Acked-by... The reason is that these tags constitute
certain endorsement of the patch and while one person may review the
patch he/she may not yet feel that review process is complete. Hope this
makes some sense...

> If possible, I want Dmitry to add
> "Reviewed-by" when he sends this driver to mainline, or I will send
> new patch again.
> 

I have it added to my copy.

-- 
Dmitry
