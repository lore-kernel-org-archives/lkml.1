Return-Path: <linux-kernel-owner+w=401wt.eu-S1756421AbXFJBQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756421AbXFJBQV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 21:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbXFJBQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 21:16:11 -0400
Received: from CHOKECHERRY.SRV.CS.CMU.EDU ([128.2.185.41]:49813 "EHLO
	chokecherry.srv.cs.cmu.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751730AbXFJBQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 21:16:10 -0400
Message-ID: <466B50C8.1090106@cs.cmu.edu>
Date: Sat, 09 Jun 2007 21:15:52 -0400
From: Benjamin Gilbert <bgilbert@cs.cmu.edu>
User-Agent: Icedove 1.5.0.8 (X11/20061208)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: akpm@linux-foundation.org, herbert@gondor.apana.org.au,
       linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] [CRYPTO] Add optimized SHA-1 implementation for i486+
References: <20070608214242.23949.30350.stgit@dev> <20070608214253.23949.40465.stgit@dev> <Pine.LNX.4.64.0706090931330.4353@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0706090931330.4353@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Jun 8 2007 17:42, Benjamin Gilbert wrote:
>> @@ -0,0 +1,299 @@
>> +/*
>> + * x86-optimized SHA1 hash algorithm (i486 and above)
>> + *
>> + * Originally from Nettle
>> + * Ported from M4 to cpp by Benjamin Gilbert <bgilbert@cs.cmu.edu>
>> + *
>> + * Copyright (C) 2004, Niels M?ller
>> + * Copyright (C) 2006-2007 Carnegie Mellon University
> 
> UTF-8 please. Hint: it should most likely be an ö.

Whoops, I had thought I had gotten that right.  I'll get updates for 
parts 2 and 3 sent out on Monday.

Thanks
--Benjamin Gilbert
