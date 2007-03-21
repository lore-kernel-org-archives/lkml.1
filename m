Return-Path: <linux-kernel-owner+w=401wt.eu-S933351AbXCUSsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933351AbXCUSsl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 14:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933629AbXCUSsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 14:48:41 -0400
Received: from mx.pathscale.com ([198.186.3.68]:60939 "EHLO mx.pathscale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933351AbXCUSsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 14:48:40 -0400
Message-ID: <46017E8D.6030703@pathscale.com>
Date: Wed, 21 Mar 2007 11:50:53 -0700
From: "Bryan O'Sullivan" <bos@pathscale.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
Cc: openib-general@openfabrics.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01 of 33] IB/ipath - add ability to set and clear IB local
 loopback
References: <b1d05f3486f8bba1dd3c.1173995085@iqa-25.internal.keyresearch.com> <adar6rllyhb.fsf@cisco.com>
In-Reply-To: <adar6rllyhb.fsf@cisco.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
> This patch format is somewhat inconvenient:

Yeah, I didn't intend for those extra bits of header cruft to go into 
the patchset (there's a "--plain" option to "hg email" that I forgot to 
use).  Sorry about that.

> And incidentally, it would be better to use "IB/ipath: " instead of
> "IB/ipath -" as a prefix, to match the canonical style of
> "<subsystem>: " for patch headers.

OK.

	<b
