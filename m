Return-Path: <linux-kernel-owner+w=401wt.eu-S1754194AbZBNVPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbZBNVPq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 16:15:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754366AbZBNVNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 16:13:54 -0500
Received: from casper.infradead.org ([85.118.1.10]:46181 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351AbZBNVNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 16:13:53 -0500
Subject: Re: RFC: install firmware in a kernel-dependent directory
From: David Woodhouse <dwmw2@infradead.org>
To: david@lang.hm
Cc: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       Michael Riepe <michael.riepe@googlemail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.0902141410220.14911@asgard.lang.hm>
References: <4996B838.2070205@googlemail.com>
	 <3f9a31f40902141115w27f20ecfk81213a21dbe1adbd@mail.gmail.com>
	 <alpine.DEB.1.10.0902141410220.14911@asgard.lang.hm>
Content-Type: text/plain
Date: Sat, 14 Feb 2009 22:13:29 +0100
Message-Id: <1234646010.12772.0.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-02-14 at 14:12 -0800, david@lang.hm wrote:
> are you sure? different firmware could have different interfaces for
> the kernel to use.
> 
> I don't know if this is a problem in practice (I think I've heard of 
> this), but there is no reason it couldn't be.

It would need different filenames then anyway (like sonames).

-- 
dwmw2

