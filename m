Return-Path: <linux-kernel-owner+w=401wt.eu-S932594AbXAWAYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932594AbXAWAYA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 19:24:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932583AbXAWAXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 19:23:42 -0500
Received: from wx-out-0506.google.com ([66.249.82.224]:47615 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932544AbXAWAXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 19:23:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=C4YHP30A5RpHr0rpUFLJlaXEvRnbbGPKZqKNHycOq2ziZXIa41gwRlvsjgEuLOIGGBGCkhiMeZysWLUt5MzGta3uVNzsK/9nQTg0xPt5qnTn3E9Hmb5rLvwvSz+RbqcbHFv5nzze/zZCTQxKSbwXM2liT8h8Nb8ivpSEGU9gP5A=
Message-ID: <9a8748490701221623q1b61f03fva7b0ad7e7f30316f@mail.gmail.com>
Date: Tue, 23 Jan 2007 01:23:29 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Chuck Ebbert" <cebbert@redhat.com>
Subject: Re: 2.6.18-stable release plans?
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Chris Wright" <chrisw@sous-sol.org>
In-Reply-To: <45B53722.9030206@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45B53722.9030206@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/01/07, Chuck Ebbert <cebbert@redhat.com> wrote:
> Is there going to be another 2.6.18-stable release?
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Now that 2.6.19 is out, most likely not.  -stable releases are made
for the latest stable 2.6.x kernel, once 2.6.x+1 is out that's the one
-stable patches are made for (2.6.16 is an exception)..


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
