Return-Path: <linux-kernel-owner+w=401wt.eu-S1751763AbZL3Dlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763AbZL3Dlx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 22:41:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbZL3Dlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 22:41:52 -0500
Received: from mtoichi11.ns.itscom.net ([219.110.2.181]:60362 "EHLO
	mtoichi11.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbZL3Dlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 22:41:52 -0500
From: hooanon05@yahoo.co.jp
Subject: Re: Q. d_alloc() in pipe(2) 
To: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <20091229150235.GA2927@hack>
References: <20021.1262066120@jrobl> <20091229150235.GA2927@hack>
Date: Wed, 30 Dec 2009 12:41:48 +0900
Message-ID: <8472.1262144508@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Amrico Wang:
> >But d_alloc() refers name->len which is uninitialized.
> 
> Well, it is initialized to 0. :)

I didn't know that.
Thanx.


J. R. Okajima
