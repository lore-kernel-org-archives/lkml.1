Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab0CHXDQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 18:03:16 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:46209 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755723Ab0CHXDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 18:03:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=jT0d0EirjutSsEs7QEvit6HtYAt3KgL9YlFJzs+eWeXWtx1n1QWPoK3PH2XY/jZiym
         afqJ+d/cO3ziJYYUsLOkjR1skGFXdEuVwHjqXEyN7xtj9/M8UQk0GOg1K+Es6HmL7n5G
         aDl7LU1J6NHGFRZHt0/wPc06AGAx9gdlAUvEM=
MIME-Version: 1.0
In-Reply-To: <4B956D26.6080602@intcomgrp.com>
References: <elPIC-7L6-15@gated-at.bofh.it> <4B954CCE.8080902@intcomgrp.com>
	 <f5ca57691003081211g2dab077cv323138699ccd03b3@mail.gmail.com>
	 <4B956D26.6080602@intcomgrp.com>
Date: Mon, 8 Mar 2010 20:03:12 -0300
Message-ID: <f5ca57691003081503v63fb867eua333ba49963f1c0a@mail.gmail.com>
Subject: Re: [PATCH] Security: key: keyring: fix code style issues
From: Chihau Chau <chihau@gmail.com>
To: James Kosin <jkosin@intcomgrp.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, Thank you, I will send a new version of the patch.

Regards.

2010/3/8 James Kosin <jkosin@intcomgrp.com>:
> On 3/8/2010 3:11 PM, Chihau Chau wrote:
>> Ok,
>>
>> And What about to include <linux/uaccess.h> instead <asm/uaccess.h> ?
>>
>> Thanks!
>>
>>
> <--snip-->
>
> It looks like the main branch is moving toward using <linux/uaccess.h>
> instead of the old <asm/uaccess.h> file; so, I'm okay with that.
>
> James K.
>



-- 
Chihau Chau
