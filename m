Return-Path: <linux-kernel-owner+w=401wt.eu-S1764971AbXEVJKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764971AbXEVJKn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 05:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755864AbXEVJKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 05:10:36 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:27597 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755570AbXEVJKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 05:10:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=msP9i+XRyXLNBwt0gyp6aG8YM42/sjUq6Voa/wnZKFSLJ1lJTXoUKtTrhVtswgVXGBQ7hyNS8nQJERMV/xRUyipekkYvXyBkyRzZ0zaG2UzUl31xjuby2tQz/6h2at6yw5Msk2SKont0SuJ9wKnABe9CvZbn9wpcLSDJ9Jh1uko=
Message-ID: <4cefeab80705220210s98c6784k76c9d9752676112a@mail.gmail.com>
Date: Tue, 22 May 2007 14:40:34 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: [RFC] LZO1X de/compression support
Cc: linux-kernel@vger.kernel.org, "Richard Purdie" <richard@openedhand.com>
In-Reply-To: <4652B0E3.5090601@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4cefeab80705180258g516a6f92w15a49e666dd62b66@mail.gmail.com>
	 <84144f020705180342j4ff44d96iea5b73c23a69df0f@mail.gmail.com>
	 <4cefeab80705220154k2b02a264id7774600087a80e5@mail.gmail.com>
	 <4652B0E3.5090601@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/22/07, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> Nitin Gupta wrote:
> > What if compiler decides not to actully inline them? In that case
> > there will be significant perf. hit.
>
> Then you use __always_inline.
>
>                         Pekka
>

Ok. I will make them inline functions now.

Thanks,
Nitin
