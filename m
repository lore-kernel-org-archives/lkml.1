Return-Path: <linux-kernel-owner+w=401wt.eu-S933172AbXHYH4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933172AbXHYH4a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 03:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760280AbXHYH4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 03:56:21 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:2399 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760275AbXHYH4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 03:56:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KAIFkTWlF7RxJJxE3BquIgJSZSVGnFBQm44Hge07+wtiAheBN9IWeeoTRUEhnPg3MBm5Er7AApfNbWdF0yt8TJrrUM7NVHpSmphDTCQr13S2VDYtFY46lNSsgi+ORrxC9uPwBecf2pqpKoBEQuVU1dLDBF3ekvdvNe0uBOpJ64s=
Message-ID: <21d7e9970708250056g561912fk45b4b943b0a353e3@mail.gmail.com>
Date: Sat, 25 Aug 2007 17:56:19 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Oleg Nesterov" <oleg@tv-sign.ru>
Subject: Re: What does drm do with signals?
Cc: "Dave Airlie" <airlied@redhat.com>, "Roland McGrath" <roland@redhat.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070823155825.GA1536@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070823155825.GA1536@tv-sign.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/24/07, Oleg Nesterov <oleg@tv-sign.ru> wrote:
> Could someone please explain why do we need block_all_signals() ?
>
> I can't understand what was the intended behaviour, but anyway
> I suspect it doesn't work as expected.

http://dri.sourceforge.net/doc/drm_low_level.html

Section 4.1 explains the intent...

Dave.
