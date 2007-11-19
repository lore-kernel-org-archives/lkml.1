Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbXKSSbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbXKSSbp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 13:31:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752351AbXKSSZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 13:25:51 -0500
Received: from stinky.trash.net ([213.144.137.162]:40269 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793AbXKSSZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 13:25:49 -0500
Message-ID: <4741D515.3050900@trash.net>
Date: Mon, 19 Nov 2007 19:25:25 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: herbert@gondor.apana.org.au, johnpol@2ka.mipt.ru,
       linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [HIFN 00/03]: RNG support v2
References: <20071118213241.9217.7696.sendpatchset@localhost.localdomain> <200711191919.42466.mb@bu3sch.de>
In-Reply-To: <200711191919.42466.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Buesch wrote:
> On Sunday 18 November 2007 22:32:52 Patrick McHardy wrote:
>> These patches add support for using the HIFN rng.
> 
> Acked-by: Michael Buesch <mb@bu3sch.de>
> 
> Patrick, can you send this patchset to Andrew for inclusion into -mm?


I think he already pulls from Herbert's cryptodev-2.6 tree
(otherwise the patches useless anyway since the HIFN driver
is only in that tree).

