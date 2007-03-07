Return-Path: <linux-kernel-owner+w=401wt.eu-S965585AbXCGQ4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965585AbXCGQ4c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 11:56:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965583AbXCGQ4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 11:56:32 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:60334 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965585AbXCGQ4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 11:56:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dWtQ6LH4Y9AQrA9EKpvRifEXVKx02sANJEek6XF9zcqnsp8t7O1gJfy873SDaVb9yNsPQecaEsDANSdNyTAbyYUlz4C92NKMZQ788n3LbpOkcz5m9mFrJrLTePRHZ2W0QZXP1Sp/3H9RJdN083jOSQFEwxasAUyJqeZRbwXx5/8=
Message-ID: <d120d5000703070856of068f19k62c5a7ce1f829336@mail.gmail.com>
Date: Wed, 7 Mar 2007 11:56:27 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH 1/1] Input: add sensable phantom driver
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@atrey.karlin.mff.cuni.cz, "Greg KH" <gregkh@suse.de>
In-Reply-To: <45EEEAA3.50009@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2460126662758025813@fi.muni.cz>
	 <d120d5000703070647t223f8858i8c495dcc3e1378a2@mail.gmail.com>
	 <45EEEAA3.50009@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/7/07, Jiri Slaby <jirislaby@gmail.com> wrote:
> Dmitry Torokhov napsal(a):
> > Hi Jiri,
>
> Hi.
>
> > On 3/7/07, Jiri Slaby <jirislaby@gmail.com> wrote:
> >> add sensable phantom driver
> > ...
> >
> > General question - can this driver use force-feedback mecahnisms
> > already present in kernel instead of exporting raw datastream to
> > userspace. What are shortcomings of kernels force-feedback
> > implemenattion that make it insufficient for phantom?
>
> I didn't even think about it, sorry. Does any problem with rate about 2kHz come
> on your mind before I'll try to rewrite it?

No, not really.

-- 
Dmitry
