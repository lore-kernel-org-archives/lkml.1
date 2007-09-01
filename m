Return-Path: <linux-kernel-owner+w=401wt.eu-S1757891AbXIAV1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757891AbXIAV1U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 17:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756164AbXIAV1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 17:27:08 -0400
Received: from wx-out-0506.google.com ([66.249.82.236]:42106 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494AbXIAV1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 17:27:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dLUXYRKQ57z3pLbB0aJ0fipWTkmZrtdJ0aveBZEyTNlh8kiWjBE14Rdjk5Z2cDSLmQZfr3dJMG/bnnMWDwn0dSPAMkdMtNCvzWvEhUiPQtdvjqFtmb3Y4Gs6FgfOhuglKActe9rb9o2B8Z07sv3BJEpuT13nsGbX1gMoGtRjVd8=
Message-ID: <f34ca13c0709011427u7a9cc97bp75c035afed3e5a63@mail.gmail.com>
Date: Sat, 1 Sep 2007 17:27:03 -0400
From: "Constantine A. Murenin" <mureninc@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: Fwd: That whole "Linux stealing our code" thing
Cc: "Jeff Garzik" <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <20070901205457.GK9260@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200709010140.l811eq9H005896@cvs.openbsd.org>
	 <f34ca13c0709010948v67b04b58lb098713dc38c4d6a@mail.gmail.com>
	 <46D99FB7.6030505@garzik.org>
	 <f34ca13c0709011037p221cb40fjf69651d1858df212@mail.gmail.com>
	 <20070901205457.GK9260@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/07, Adrian Bunk <bunk@kernel.org> wrote:
> On Sat, Sep 01, 2007 at 01:37:18PM -0400, Constantine A. Murenin wrote:
> > On 01/09/07, Jeff Garzik <jeff@garzik.org> wrote:
> > > Constantine A. Murenin wrote:
> > > > This will hopefully help diminish certain myths about the code licensing.
> > >
> > > What myth?  The myth that Theo understands dual licensing?
> >
> > Reyk's code was never dual licensed, so it's not like it even matters
> > to the original dispute.
>
> It's no longer dual licenced in the FreeBSD tree because the FreeBSD
> people removed the GPL choice of the dual licenced code 3 months ago.

FreeBSD doesn't have Reyk's ath(4) HAL, which OpenHAL is based on.

FreeBSD has a driver written by Sam, and a binary-only HAL, also written by Sam.

> So all of Theo's accusations of people breaking the law by making this
> dual licenced code GPL-only apply as well to the FreeBSD people...

How? FreeBSD doesn't have Reyk's ath(4) HAL from OpenBSD, so there are
no possible licensing accusations and violations.

> > That said, I don't see what exact wording you consider inaccurate.
>
> Both the FreeBSD and Linux people draw the logical conclusion that this
> "Alternatively" means everyone can always choose to remove one of the
> two choices alternatively offered.
>
> According to Theo, that is "breaking the law"...

FreeBSD's ath(4) code, both the driver and the HAL, is entirely
written by Sam Leffler, who can licence it in whichever way he seems
reasonable. The driver part of Sam's code is also present in OpenBSD,
but the HALs in OpenBSD and FreeBSD are entirely different.

C.
