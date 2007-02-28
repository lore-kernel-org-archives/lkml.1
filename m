Return-Path: <linux-kernel-owner+w=401wt.eu-S1751750AbXB1To4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750AbXB1To4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 14:44:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbXB1To4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 14:44:56 -0500
Received: from smtp.nokia.com ([131.228.20.172]:58858 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbXB1Toz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 14:44:55 -0500
Subject: Re: [PATCH 0/5] Add LZO Compression
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Richard Purdie <rpurdie@openedhand.com>
Cc: LKML <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>,
       herbert@gondor.apana.org.au, linux-mtd <linux-mtd@lists.infradead.org>,
       linux-crypto@vger.kernel.org
In-Reply-To: <1172689998.16062.135.camel@localhost.localdomain>
References: <1172689998.16062.135.camel@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Date: Wed, 28 Feb 2007 21:43:46 +0200
Message-Id: <1172691826.17031.37.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 28 Feb 2007 19:43:47.0237 (UTC) FILETIME=[C32DC550:01C75B70]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070228214131-6F1C1BB0-1233A26E/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-28 at 19:13 +0000, Richard Purdie wrote:
> The following patch series adds LZO compression support to the kernel
> and exposes it in a variety of places (jffs2, crypto).
> 
> This is particularly useful for jffs2 where significant boot time
> speedups (~10%) and file read speed improvements (~40%) are seen when
> its used with only a slight drop in file compression ratio.

Providing the digits are accurate, this is very good stuff.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

