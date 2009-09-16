Return-Path: <linux-kernel-owner+w=401wt.eu-S1759661AbZIPQdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759661AbZIPQdz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 12:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753724AbZIPQdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 12:33:50 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:55005 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093AbZIPQdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 12:33:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=pQ70H457Z3M1Vbr8eSfUIUe8gpAKZqi66twjhKrF+A5YMXZqsHNiKDg8Q085Z07j/I
         pSgsBgOBssV8/fIaeB3704EXnSf3ju8uEW+MnY8V8NNMsX9olow+D7oI/92rPDjYEWsE
         BJ6RF9HJ3rEhqLlo+WIucIM5rHGMUwl2CSLZQ=
Date: Wed, 16 Sep 2009 09:33:46 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       linux-input@vger.kernel.org
Subject: Re: [Uclinux-dist-devel] [PATCH v2] input/keyboard: add ADP5588
	QWERTY I2C Keyboard Input device driver
Message-ID: <20090916163345.GC4970@core.coreip.homeip.net>
References: <20090915062050.GB10232@core.coreip.homeip.net> <1253062178-18196-1-git-send-email-vapier@gentoo.org> <20090916050236.GF2756@core.coreip.homeip.net> <8bd0f97a0909160555n390ad48dhf19c7eac5c3783fe@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8bd0f97a0909160555n390ad48dhf19c7eac5c3783fe@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 08:55:13AM -0400, Mike Frysinger wrote:
> On Wed, Sep 16, 2009 at 01:02, Dmitry Torokhov wrote:
> > On Tue, Sep 15, 2009 at 08:49:38PM -0400, Mike Frysinger wrote:
> >> From: Michael Hennerich <michael.hennerich@analog.com>
> >>
> >> Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
> >> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> >> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> >> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> >> ---
> >> v2
> >>       - merge my and Dmitry's clean up fixes
> >>
> >
> > Looks good, I'd also like to add this instead of recalcularing delay
> > every time:
> 
> makes sense to me.  you going to merge that, or should i merge & repost as v3 ?

If you could merge and test this would be great - I obviously don't have
the hardware.

-- 
Dmitry
