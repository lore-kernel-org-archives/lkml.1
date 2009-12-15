Return-Path: <linux-kernel-owner+w=401wt.eu-S1756818AbZLOX0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818AbZLOX0Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 18:26:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752494AbZLOX0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 18:26:21 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:59696 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbZLOX0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 18:26:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=VUqpT+2YqUoV68ZwUUiukpxPEZMojg0OgbB1OXxZ8zVLRTphRxpauO2yR4nWRwoJWn
         hFRvI7Y7YRliRg4SPV6VU66ewRm3NrosqZlvXLGrTXjCryW4UhctditPOrOmPXgY8biP
         XmUjIqrh7/J4s8/6JCSK27aY9Fe2HtlhJH59w=
MIME-Version: 1.0
In-Reply-To: <20091214.214923.241454954.davem@davemloft.net>
References: <d45a3acc0912141402v69ea4ccet143f8ef7bc04e585@mail.gmail.com>
	 <20091214.214923.241454954.davem@davemloft.net>
Date: Wed, 16 Dec 2009 10:26:19 +1100
Message-ID: <d45a3acc0912151526n2de0a64bh3dc0221fc2720d3e@mail.gmail.com>
Subject: Re: [RESEND PATCH 1/3] X25: Move SYSCTL ifdefs into header
From: andrew hendry <andrew.hendry@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, ignore these resends, all 3 are were in net-2.6 and made it to linux-next
2f5517aefcfbdd7fdf0f03b13d292a10d445887f
1fd975a0520cdb27681855d5a18526e328d36b5c
429d33ace5ce6122817f8abe9d170eaa55dc3af9
I'll watch git in the future, not the mailing list pull requests to track.

On Tue, Dec 15, 2009 at 4:49 PM, David Miller <davem@davemloft.net> wrote:
>
> These patches do not apply to the current sources.
>
> Please respin them against net-2.6
>
> In fact it looks like at least your first patch is already in the
> tree.
>
