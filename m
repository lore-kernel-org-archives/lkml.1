Return-Path: <linux-kernel-owner+w=401wt.eu-S1755439AbZBXGko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439AbZBXGko (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 01:40:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752855AbZBXGkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 01:40:33 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:21982 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbZBXGkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 01:40:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JGx4bC6Ad90lujpCVv9R0ffZLwep76FI3plbmKGAoS9GLtbDQAYzqBTGbE9RNtQXwi
         g5fzx7QI7Bu18RRF9O7vglfB5JPZxKEZqtc20RAMFf4ssW0bNMowhWPJGMR5FmwyvxFK
         v9kJelWmqfWit8Ze9Dku3ATS84zuq2rgAQtFM=
MIME-Version: 1.0
In-Reply-To: <20090221.235308.172360407.davem@davemloft.net>
References: <Pine.LNX.4.64.0902091513190.31742@wrl-59.cs.helsinki.fi>
	 <20090221132424.GA28861@gondor.apana.org.au>
	 <Pine.LNX.4.64.0902212042420.20526@wrl-59.cs.helsinki.fi>
	 <20090221.235308.172360407.davem@davemloft.net>
Date: Tue, 24 Feb 2009 14:40:30 +0800
Message-ID: <b6a2187b0902232240m6f2347efs84639bb59a19269e@mail.gmail.com>
Subject: Re: commit 64ff3b938ec6782e6585a83d5459b98b0c3f6eb8 breaks rlogin
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: ilpo.jarvinen@helsinki.fi, herbert@gondor.apana.org.au, rjw@sisk.pl,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 22, 2009 at 3:53 PM, David Miller <davem@davemloft.net> wrote:

> Sure, but I'll give Herbert one more chance :-)
>
> Applied to net-next-2.6

I see that this is already in linux-2.6.29-rc6. Tested and working fine.

Thanks,
Jeff.
