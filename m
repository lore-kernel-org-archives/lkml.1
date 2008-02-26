Return-Path: <linux-kernel-owner+w=401wt.eu-S1759412AbYBZNj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759412AbYBZNj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 08:39:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753199AbYBZNju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 08:39:50 -0500
Received: from sorrow.cyrius.com ([65.19.161.204]:4041 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753139AbYBZNjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 08:39:49 -0500
Date: Tue, 26 Feb 2008 14:39:08 +0100
From: Martin Michlmayr <tbm@cyrius.com>
To: Patrick McHardy <kaber@trash.net>
Cc: linux-kernel@vger.kernel.org, Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: Re: 2.6.25-rc3: "__divdi3" [drivers/crypto/hifn_795x.ko] undefined!
Message-ID: <20080226133907.GA2655@deprecation.cyrius.com>
References: <20080226122100.GB22699@deprecation.cyrius.com> <47C40603.8060908@trash.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C40603.8060908@trash.net>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Patrick McHardy <kaber@trash.net> [2008-02-26 13:28]:
>> I get the following build error on at least ARM and MIPS:
>>   Building modules, stage 2.
>>   MODPOST 759 modules
>> ERROR: "__divdi3" [drivers/crypto/hifn_795x.ko] undefined!
>
> Does this patch fix it?

Nope.
-- 
Martin Michlmayr
http://www.cyrius.com/
