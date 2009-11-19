Return-Path: <linux-kernel-owner+w=401wt.eu-S1757434AbZKSKry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434AbZKSKry (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 05:47:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756149AbZKSKry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 05:47:54 -0500
Received: from mail.atmel.fr ([81.80.104.162]:40756 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755811AbZKSKrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 05:47:53 -0500
X-Greylist: delayed 78139 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Nov 2009 05:47:52 EST
Message-ID: <4B05224B.8050403@atmel.com>
Date: Thu, 19 Nov 2009 11:47:39 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, avictor.za@gmail.com
CC: linux-input@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] input: atmel_tsadcc: touchscreen rework setting	capabilities
References: <693b9933de6fe9eb7e4401ca56a8f9ab6a966666.1258553002.git.nicolas.ferre@atmel.com> <20091118173033.GA4385@core.coreip.homeip.net>
In-Reply-To: <20091118173033.GA4385@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov :
> Hi Nicolas,
> 
> On Wed, Nov 18, 2009 at 03:12:12PM +0100, Nicolas Ferre wrote:
>> Tiny patch for setting capabilities using input API function.
>>
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> 
> All looks good. Since the series span platform and input subtrees how do
> you want to merge it?

I propose that you merge the whole series using the input path.

I had the acknowledgment from Andrew Victor offline. So, could you
please add on patches #3 & #4:

Acked-by: Andrew Victor <linux@maxim.org.za>

Thanks a lot.

Best regards,
-- 
Nicolas Ferre

