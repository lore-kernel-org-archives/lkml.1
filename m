Return-Path: <linux-kernel-owner+w=401wt.eu-S1754700AbZHJN2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700AbZHJN2G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 09:28:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754403AbZHJN2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 09:28:05 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:38978 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754268AbZHJN2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 09:28:05 -0400
Subject: Re: [PATCH] kmemcheck: includecheck fix for shadow.c
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, vegardno@ifi.uio.no,
       Pekka Enberg <penberg@cs.helsinki.fi>
In-Reply-To: <1249821367.2957.1.camel@ht.satnam>
References: <1249821367.2957.1.camel@ht.satnam>
Content-Type: text/plain
Organization: ARM Ltd
Date: Mon, 10 Aug 2009 14:27:05 +0100
Message-Id: <1249910825.10848.4.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Aug 2009 13:27:06.0782 (UTC) FILETIME=[418E83E0:01CA19BE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-08-09 at 18:06 +0530, Jaswinder Singh Rajput wrote:
> fix the following 'make includecheck' warning:
> 
>   arch/x86/mm/kmemcheck/shadow.c: linux/module.h is included more than once.
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>

I think this should have been sent to the kmemcheck maintainers (I
maintain kmemleak - pretty confusing names).

-- 
Catalin

