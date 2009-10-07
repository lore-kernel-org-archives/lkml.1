Return-Path: <linux-kernel-owner+w=401wt.eu-S1759573AbZJGQfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759573AbZJGQfF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 12:35:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759558AbZJGQfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 12:35:04 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:54546 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759550AbZJGQfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 12:35:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=Z+u7APv5IyzL9UrB/1LeBPyBwRTCzbhRg2xprpqJ1ewOiwjWZru895Jlq9mJymXvW8
         nD3NHYoXsC28xQaUgxW7J6+7DM81mw0K6dt09MyQoHPtWAlH7LYAl7kfEVxx6tRa3Cr+
         MjcDCZ165kKQMBpjoyvJaIa0TEp/b6/0nA1cg=
Date: Wed, 7 Oct 2009 09:34:17 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Trilok Soni <soni.trilok@gmail.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: Re: [PATCH 3/6] Haptic: Add haptic maintainer
Message-ID: <20091007163416.GB12053@core.coreip.homeip.net>
References: <20091007061805.GA7592@july> <5d5443650910070006s1aae5fecmec9f6a24a2e272c5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5d5443650910070006s1aae5fecmec9f6a24a2e272c5@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 07, 2009 at 12:36:47PM +0530, Trilok Soni wrote:
> On Wed, Oct 7, 2009 at 11:48 AM, Kyungmin Park
> <kyungmin.park@samsung.com> wrote:
> > Add me to haptic class maintainer
> >
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >  MAINTAINERS |    7 +++++++
> >  1 files changed, 7 insertions(+), 0 deletions(-)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 09a2028..906b603 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -2287,6 +2287,13 @@ F:       Documentation/isdn/README.gigaset
> >  F:     drivers/isdn/gigaset/
> >  F:     include/linux/gigaset_dev.h
> >
> > +HAPTIC SUBSYSTEM
> > +M:     Kyungmin Park <kyungmin.park@samsung.com>
> > +L:     linux-input@vger.kernel.org
> 
> Dmitry,
> 
> Are you OK if we use linux-input for haptics class patches? OR else we
> will just use linux-kernel.

Sure, I don't have any issues with haptics using linux-input.

-- 
Dmitry
