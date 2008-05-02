Return-Path: <linux-kernel-owner+w=401wt.eu-S934482AbYEBM4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934482AbYEBM4F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 08:56:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760331AbYEBMzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 08:55:52 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:5670 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760048AbYEBMzv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 08:55:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:in-reply-to:references:organization:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=HJpkfednRBGwptnlXvB/vGQsJvgeuS5B7Y4eyYXO8JE+nUa87qwX8WYTx0XEv00H2KDz4ho7qfyfK+7BV8mLR1Q9T4J9F2UAUz5fvJTHLI7+vEn8jlGynOHJy3TWEPAfpI1K3skqGnKoTvQXIsegqArL4wuVLrOkGjvSsmW3ec4=
Date: Fri, 2 May 2008 13:58:12 +0200
To: David Woodhouse <dwmw2@infradead.org>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Paul Gortmaker <paul.gortmaker@windriver.com>,
       linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tim Bird <tim.bird@am.sony.com>
Subject: Re: [PATCH 0/1] Embedded Maintainer(s), linux-embedded@vger list
Message-Id: <20080502135812.b9544959.Kristoffer.Ericson@Gmail.com>
In-Reply-To: <1209577322.25560.402.camel@pmac.infradead.org>
References: <1209577322.25560.402.camel@pmac.infradead.org>
Organization: JLime
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008 18:42:02 +0100
David Woodhouse <dwmw2@infradead.org> wrote:

> Andrew Morton has been saying recently that we need an 'embedded
> maintainer', to take responsibility for 'embedded issues' in the core
> kernel, as well as trying to improve our relationship with those using
> the Linux kernel for 'embedded' devices -- who have a reputation of
> not working with us very closely; to their detriment as well as our
> own.

Sounds like a good idea. I doubt it will change much concerning development
but it would be good to have some "representation" for embedded stuff.

> 
> Various people, including myself, have been doing that kind of thing
> on and off over the years anyway, but Andrew is probably right that
> it's worth having someone listed in the MAINTAINERS file who actually
> considers it their responsibility, and as a point of contact for
> people seeking advice, review, etc.
> 

Agreed.

> I've volunteered to take a more active rôle in this, and Wind River
> has agreed to assign Paul Gortmaker to it, too.  The following patch
> adds both of us to the MAINTAINERS file.
> 
> We have also set up a mailing list, linux-embedded@vger.kernel.org,
> where development related to embedded stuff can happen in a slightly
> less noisy environment than the main linux-kernel list. We'd like to
> encourage anyone working on Linux in embedded devices to join the list.
> 
> -- 
> dwmw2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Kristoffer Ericson <Kristoffer.Ericson@Gmail.com>
