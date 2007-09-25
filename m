Return-Path: <linux-kernel-owner+w=401wt.eu-S1755276AbXIYRu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276AbXIYRu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 13:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbXIYRuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 13:50:17 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:12825 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbXIYRuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 13:50:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hd7hDIqiCJ6naclsoWWumKSS/JL8vxMPWURuHVKlHUJ7hVBoM5Eg8i77MQgUOWo5vXVHrexhBkKjBHoIGz7k8uBav562WGDxgell157xgiLOmrrr7p81nWCBcK8bIHS+24R6QTj6nYXSwwKUuX0UL/sqkJ7ThutEzgHsvMZUwJc=
Message-ID: <d120d5000709251050n2ee79b15w2e3380cd6705c320@mail.gmail.com>
Date: Tue, 25 Sep 2007 13:50:12 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [git pull] Input updates for 2.6.23-rc8
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.999.0709250853000.3579@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200709250144.57533.dtor@insightbb.com>
	 <alpine.LFD.0.999.0709250853000.3579@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/25/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>
> On Tue, 25 Sep 2007, Dmitry Torokhov wrote:
> >
> > Please pull from:
> >
> >       git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
> > or
> >       master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus
> >
> > to receive updates for the input subsystem. There is only one patch
> > that fixes regression in appletouch driver introduced in previous
> > release.
>
> Nope, there is nothing at all there. Forgot to push?
>

Oops, sorry. Should be there now.

-- 
Dmitry
