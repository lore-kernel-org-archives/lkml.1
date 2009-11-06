Return-Path: <linux-kernel-owner+w=401wt.eu-S1755452AbZKFIo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbZKFIo7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 03:44:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755330AbZKFIo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 03:44:58 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:51270 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875AbZKFIo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 03:44:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=qvDDUs5KA7WDDfKwkv35D/rQna9r5k8iYorGBg6Srtb464OfhNfEQKVzipJUMb6KpU
         yJymTxE7fNxmmFHgAB5o6cJX8YUP3oIebx10xo5ZbapHAMSmddhtWTqhU8PFuFfoBys4
         04O+0ox1250QpY6PR4lSORxhodiyj/Vw2klqc=
MIME-Version: 1.0
In-Reply-To: <4AEB0059.1050400@gmail.com>
References: <38b2ab8a0909290109m3f82c161j4fb0f1266152877e@mail.gmail.com>
	 <4AC1D0F5.4050709@gmail.com>
	 <38b2ab8a0910300144i7a3c190fi9aa3d079c9cdb754@mail.gmail.com>
	 <4AEACD88.8080108@gmail.com> <4AEB0059.1050400@gmail.com>
Date: Fri, 6 Nov 2009 09:45:01 +0100
Message-ID: <38b2ab8a0911060045hb6ebab8p43bf8aa838eabfd3@mail.gmail.com>
Subject: Re: WARNING: at net/ipv4/af_inet.c:154 inet_sock_destruct
From: Francis Moreau <francis.moro@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Netdev List <netdev@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 30, 2009 at 4:03 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:

[...]

>
> [PATCH take2] net: fix sk_forward_alloc corruption
>

With this patch applied 4 days ago, I haven't got any oops so far.
-- 
Francis
