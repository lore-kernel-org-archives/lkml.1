Return-Path: <linux-kernel-owner+w=401wt.eu-S1756149AbXKEKt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149AbXKEKt5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 05:49:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753839AbXKEKtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 05:49:50 -0500
Received: from ozlabs.org ([203.10.76.45]:50721 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753833AbXKEKtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 05:49:49 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] lguest: make async_hcall() static
Date: Mon, 5 Nov 2007 21:50:14 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: lguest@ozlabs.org, linux-kernel@vger.kernel.org
References: <20071102154310.GI30287@stusta.de>
In-Reply-To: <20071102154310.GI30287@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711052150.14518.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 November 2007 02:43:10 Adrian Bunk wrote:
> async_hcall() can become static.

Thanks; I had to fix up the documentation after this, but I've put it in my 
tree (along with the others).

Cheers,
Rusty.
