Return-Path: <linux-kernel-owner+w=401wt.eu-S1756613AbZKWKD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613AbZKWKD5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 05:03:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756239AbZKWKD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 05:03:57 -0500
Received: from aa001msb.fastweb.it ([85.18.95.80]:37497 "EHLO
	aa001msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396AbZKWKD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 05:03:56 -0500
Message-ID: <4B0A5E05.3080509@evidence.eu.com>
Date: Mon, 23 Nov 2009 11:03:49 +0100
From: Claudio Scordino <claudio@evidence.eu.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH TRIVIAL] atmel_lcdfb.c: Fix sinfo->irqbase from %lu to
 	%d in dev_info().
References: <1255083621-25147-1-git-send-email-nicolas.ferre@atmel.com>	<alpine.LSU.2.00.0910091730560.19284@wotan.suse.de>	<4B0A4813.7060305@evidence.eu.com> <alpine.LSU.2.00.0911231023140.6953@wotan.suse.de>
In-Reply-To: <alpine.LSU.2.00.0911231023140.6953@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina ha scritto:
> On Mon, 23 Nov 2009, Claudio Scordino wrote:
>
>   
>>    may I ask you the current status of this patch ? I noticed that it
>> has not been merged, yet.
>>
>> Do we have any idea when it will be done ?
>>
>> Since it is a trivial fix, I think it should be merged before the
>> release of v2.6.32 (i.e., waiting the next merge window does not make
>> much sense for such a trivial fix...).
>>     
>
> I usually don't send pull requests for trivial queue to Linus more than 
> once per release cycle.
>   
Oh, I see. Sorry for the noise, then.

Many thanks again,

             Claudio

