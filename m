Return-Path: <linux-kernel-owner+w=401wt.eu-S1757349AbXHBMlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349AbXHBMlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 08:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755068AbXHBMlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 08:41:01 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:21368 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742AbXHBMk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 08:40:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=BEQtvE0rV2mNMDIGg8aNiKRw2I6sp5UDeB4KufHvkDY+JVFluOUA28B2zVCqR7rFfBo/eWZwR831aJVg3f7nIBu+WEjubpb11B3pBXk1G51Fyi2DwRRHB/tpz6GaE5bckvL9bUEYaT1fipspM1rarAfy8ljvC3O0914bfHRNQFs=
Message-ID: <46B1D0D3.5050703@gmail.com>
Date: Thu, 02 Aug 2007 21:40:51 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
CC: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sata_qstor, pdc_adma, sata_sx4: convert to new EH
References: <20070724011404.GA14064@havoc.gtf.org> <46B1CDCD.3010907@rtr.ca>
In-Reply-To: <46B1CDCD.3010907@rtr.ca>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Jeff Garzik wrote:
>> This is just a refresh of the existing libata-dev.git#new-eh patches
>> that convert all remaining old-EH drivers to new EH, against 2.6.23-rc1.
>>
>> All three conversions are completely untested.  pdc_adma and sata_qstor
>> need reviewing by someone with docs, in addition to testing.
>>
>> Even "it still works" or "this patch breaks stuff" feedback from users
>> is useful.
> 
> Tejun has some pdc_adma hardware..  ;)

Yeah, I actually have two thanks to Mark. :-)  Will test soon.

-- 
tejun
