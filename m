Return-Path: <linux-kernel-owner+w=401wt.eu-S1750935AbXCSSKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750935AbXCSSKp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 14:10:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030463AbXCSSKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 14:10:45 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:34049 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbXCSSKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 14:10:44 -0400
Date: Mon, 19 Mar 2007 20:10:42 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm snapshot broken-out-2007-03-18-02-44.tar.gz uploaded
In-Reply-To: <45FED032.2000301@googlemail.com>
Message-ID: <Pine.LNX.4.64.0703192008210.25294@sbz-30.cs.Helsinki.FI>
References: <200703180946.l2I9kTVc020636@shell0.pdx.osdl.net> 
 <45FD8684.4030501@googlemail.com>  <6bffcb0e0703190845s6bdc1a65p71937d1dffbf6d9e@mail.gmail.com>
  <Pine.LNX.4.64.0703191751560.21196@sbz-30.cs.Helsinki.FI> 
 <6bffcb0e0703190929rd118b16u21552da0c81b9f04@mail.gmail.com> 
 <Pine.LNX.4.64.0703191836370.22180@sbz-30.cs.Helsinki.FI> 
 <6bffcb0e0703190945i5f783ea9ie8195fa084b2c13f@mail.gmail.com>
 <6bffcb0e0703191024w527638f8yacc3a8fea9fd451d@mail.gmail.com>
 <45FED032.2000301@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2007, Michal Piotrowski wrote:
> Here is a tested patch.

[snip]

> Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
> Signed-off-by: Pekka J Enberg <penberg@cs.helsinki.fi>

You're not supposed to add sign-offs for anyone else but yourself. This 
patch did not pass through me so please remove it.

Anyway, the fix looks good. Thanks.

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
