Return-Path: <linux-kernel-owner+w=401wt.eu-S965705AbXCPRU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965705AbXCPRU1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 13:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965757AbXCPRU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 13:20:27 -0400
Received: from gepetto.dc.ltu.se ([130.240.42.40]:50466 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965705AbXCPRU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 13:20:26 -0400
Message-ID: <45FACF2E.3040600@student.ltu.se>
Date: Fri, 16 Mar 2007 18:09:02 +0100
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Bernd Petrovitsch <bernd@firmix.at>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Kernel Janitors List <kernel-janitors@lists.osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] A need for "yesno"-function? (and "cleanup" of kernel.h)
 (was: Re: [KJ] [RFC] A need for a "yesno"-function?)
References: <45F95351.60308@student.ltu.se>	 <39e6f6c70703152036m778ea054gf32723d0eda2be68@mail.gmail.com>	 <45FAB6C5.8050302@student.ltu.se> <1174062833.26648.56.camel@tara.firmix.at>
In-Reply-To: <1174062833.26648.56.camel@tara.firmix.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bernd Petrovitsch wrote:
> On Fri, 2007-03-16 at 16:24 +0100, Richard Knutsson wrote:
> [...]
>   
>> more readable). The big problem is, where to put it? Seems wrong to put 
>> in <linux/string.h> since it appear to be a replica of userspace's 
>> <string.h> (otherwise, why put mem*-functions in there?).
>>     
>
> memcpy(3) and memcmp(3) are also there in user-space.
>   
Did I miss something or did you just restate what was stated? (If it was 
not a replica, I think the mem*-functions would be better placed in 
memory.h, or such)

Richard Knutsson

