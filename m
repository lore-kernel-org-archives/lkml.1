Return-Path: <linux-kernel-owner+w=401wt.eu-S1758572AbYAUH4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572AbYAUH4X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 02:56:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757417AbYAUH4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 02:56:16 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:61635 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757396AbYAUH4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 02:56:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EZZLRxMoSgc7W4aVbDBlBMcVUx53YiqAUVNj29iFSWPWX8ujQ3IFODKT75AP+jRm9EfRzjDJk95n2H3gdSg5khSkzCerxAayHXQpzfTaHgfmT57uWVhE3TA6LM1zBgqfJbIzdBI/S2h5DFT3ruVpiEc/ozU3fZqNfbAmXsfqVro=
Message-ID: <36ca99e90801202356n745fa848r3d1ec8ff157ccfff@mail.gmail.com>
Date: Mon, 21 Jan 2008 08:56:14 +0100
From: "Bert Wesarg" <bert.wesarg@googlemail.com>
To: "Rusty Russell" <rusty@rustcorp.com.au>
Subject: Re: [PATCH 2/6] typesafe: kthread_create and kthread_run
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200801210904.57266.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801202046.14746.rusty@rustcorp.com.au>
	 <87ve5otqgl.fsf@saeurebad.de>
	 <36ca99e90801200843p7f45ef6ay281b5e77848f6d32@mail.gmail.com>
	 <200801210904.57266.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 20, 2008 11:04 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Monday 21 January 2008 03:43:40 Bert Wesarg wrote:
> > No, it is a matter of conforming to C99 or to GNU extensions.
>
> Hi Bert!
>
> Not sure I see the point of your message.
>
> The original use the ... varargs GNU extension, your two argument version is
> the C99-safe variant, and your three args + __VA_ARGS__ uses the gcc ##
> extension.
You're right. I didn't know that the ## is a gnu extension too,
thanks. I thought C99 did it right from the beginning.

Sincerely
Bert

>
> Cheers,
> Rusty.
>
