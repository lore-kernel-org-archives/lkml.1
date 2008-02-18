Return-Path: <linux-kernel-owner+w=401wt.eu-S1762022AbYBRNGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762022AbYBRNGi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 08:06:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760791AbYBRNFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 08:05:15 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:22824 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760814AbYBRNFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 08:05:12 -0500
Message-ID: <47B98285.3060503@msgid.tls.msk.ru>
Date: Mon, 18 Feb 2008 16:05:09 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-nfs@vger.kernel.org
Subject: Re: 2.6.24: RPC: bad TCP reclen 0x00020090 (large)
References: <47B2F88D.7080300@msgid.tls.msk.ru> <20080218045812.f1dc6f71.akpm@linux-foundation.org>
In-Reply-To: <20080218045812.f1dc6f71.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> (suitable cc added)

Thanks.  I was meant to sent it to linux-nfs originally, but
looks like i mistyped the address.

> (regression)

Now, after we did some more experiments with it, I don't think it's
a regression.  I'll post a bit more details in a few hours when the
ongoing testing finishes.  Thanks!

/mjt
