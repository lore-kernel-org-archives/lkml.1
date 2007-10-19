Return-Path: <linux-kernel-owner+w=401wt.eu-S966857AbXJSJXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966857AbXJSJXd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 05:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755452AbXJSJX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 05:23:26 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:36198 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263AbXJSJXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 05:23:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oVKf6Fo4kbGSjtOpG0mIbBoqQknpWzxRQwcZDGUNAWaQryJL2ExHPUOtffxyMlqruQYlZPWdnGyK+rvGcrJhS/3Km9ENOMnaG+uwTL3GeBdm8WcyPyORlZ5PvW2Cdio+oB7HXp0pRAaHQS3YuJ9j5BXg869+apwVicQw72TeNtA=
Message-ID: <386072610710190223n4f7613eeve6950fcb5fbe1426@mail.gmail.com>
Date: Fri, 19 Oct 2007 17:23:24 +0800
From: "Bryan Wu" <cooloney.lkml@gmail.com>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: [PATCH] Blackfin I2C/TWI driver: update for 2.6.24 merge windows
Cc: bryan.wu@analog.com, i2c@lm-sensors.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <20071019110750.33f66dd8@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1192456403.6215.5.camel@roc-laptop>
	 <386072610710172311o7d2207f2he47e16c48016c2c2@mail.gmail.com>
	 <20071019110750.33f66dd8@hyperion.delvare>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/07, Jean Delvare <khali@linux-fr.org> wrote:
> Hi Bryan,
>
> On Thu, 18 Oct 2007 14:11:35 +0800, Bryan Wu wrote:
> > Could you kindly review this patch?
>
> I'm pretty busy these days, I don't have much spare time for reviews.
>
> BTW, as a rule of thumb, I am ignoring patches that are sent to the
> LKML in addition to the i2c list. If you think that your patch is so
> important that it has to be send to a list with over 4500 subscribers
> that sees 120.000 messages each year, then who am I to dare to comment
> on it?
>
> If you want me to consider your patches as something that needs my
> attention, send them to the i2c list only, do not add LKML. This is
> general advice for everyone sending i2c patches, not just you, of
> course.
>
I see. Actually this is the first time I was told about it.
Thanks for the clarification.

> Back to your patch... Originally you posted two patches, and I see that
> they are now merged into a single patch, why? It's much better to have
> separate patches, it makes reviews and testing way easier. If you
> provide separate patches I'll try to find some time to review them.
>
OK, I will send separate patch later.


> Note that this won't be for 2.6.24 anyway, it's too late for that, I've
> already sent my i2c patches to Linus. From now on, only bugfixes can go
> in 2.6.24, improvements will have to wait for 2.6.25.
>
I know it missed the merge window.

Thanks again
-Bryan Wu
