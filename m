Return-Path: <linux-kernel-owner+w=401wt.eu-S1751893AbXKDQgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893AbXKDQgA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 11:36:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbXKDQfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 11:35:50 -0500
Received: from [212.12.190.113] ([212.12.190.113]:33751 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752467AbXKDQft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 11:35:49 -0500
From: Al Boldi <a1426z@gawab.com>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Massive slowdown when re-querying large nfs dir
Date: Sun, 4 Nov 2007 19:03:12 +0300
User-Agent: KMail/1.5
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200711050758.38090.a1426z@gawab.com> <20071104133642.GS15111@parisc-linux.org>
In-Reply-To: <20071104133642.GS15111@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711041903.12976.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> How about tcpdumping and seeing what requests are flowing across the
> wire?  You might be able to figure out what's being done differently.

I think lookup is faster than getattr.


Thanks!

--
Al

