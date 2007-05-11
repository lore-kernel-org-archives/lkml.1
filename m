Return-Path: <linux-kernel-owner+w=401wt.eu-S934295AbXEKVZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934295AbXEKVZ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 17:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760857AbXEKVZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 17:25:21 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:8498 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760637AbXEKVZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 17:25:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qVH/jlKjceqrDTgVDSMuCgI/8nOyHWRTw2Pvw/UEHJVJtjwrxGzXgajsXcP/j4BIlnXLIgRH4zcOP8hWH6DvHEHJk2hpjsO6qtQRgDsZIoEQDJwWuknXTyPe+czObnljlVcW0HjXh8qVS0Xcw27l4JYwqLAPP6BPpmHD7w6OB1k=
Message-ID: <9a8748490705111425r3e7021f2t5508f58dd16a6f76@mail.gmail.com>
Date: Fri, 11 May 2007 23:25:18 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Jonathan Corbet" <corbet@lwn.net>
Subject: Re: [PATCH] "volatile considered harmful", take 3
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Johannes Stezenbach" <js@linuxtv.org>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Heikki Orsila" <shdl@zakalwe.fi>, "H. Peter Anvin" <hpa@zytor.com>,
       "Satyam Sharma" <satyam.sharma@gmail.com>,
       "jimmy bahuleyan" <knight.camelot@gmail.com>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>
In-Reply-To: <12700.1178905000@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12700.1178905000@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/07, Jonathan Corbet <corbet@lwn.net> wrote:
> Here's another version of the volatile document.  Once again, I've tried
> to address all of the comments.  There haven't really been any recent
> comments addressing the correctness of the document; people have been
> more concerned with how it's expressed.  I'm glad to see files in
> Documentation/ held to a high standard of writing, but, unless somebody
> has a factual issue this time around I would like to declare Mission
> Accomplished and move on.
>
> Thanks,
>
> jon
>
> ---
>
> Encourage developers to avoid the volatile type class in kernel code.
>
> Signed-off-by: Jonathan Corbet <corbet@lwn.net>
>

Looks good to me.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
