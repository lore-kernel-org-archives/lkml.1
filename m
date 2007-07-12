Return-Path: <linux-kernel-owner+w=401wt.eu-S1763441AbXGLIbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763441AbXGLIbl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 04:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761746AbXGLIbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 04:31:16 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:27404 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761630AbXGLIbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 04:31:13 -0400
Date: Thu, 12 Jul 2007 10:31:12 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Denis Vlasenko <vda.linux@googlemail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Douglas W. Jones" <jones@cs.uiowa.edu>
Subject: Re: [PATCH 2/2] vsprintf.c: optimizing, part 2: base 10 conversion
 speedup, v2
In-Reply-To: <200707112326.13565.vda.linux@googlemail.com>
Message-ID: <Pine.LNX.4.64.0707121030340.11053@fbirervta.pbzchgretzou.qr>
References: <200707051251.52891.vda.linux@googlemail.com>
 <20070705143419.f214f5b2.akpm@linux-foundation.org>
 <200707112326.13565.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 12 2007 01:26, Denis Vlasenko wrote:
>> Neither of your patches had signed-off-by:s.  Would prefer that they were
>> included please, given that we're adding stuff from someone's website.
>
>Sorry. Consider this added to both patches:
>
>Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
>
>Yes. "Denys" is how Ukrainian bureaucracy insists on spelling my name.
>This Signed-off-by thing is official, so here it goes.
>Informally please use "Denis".

Just spell it out in Cyrillic :)




	Jan
-- 
