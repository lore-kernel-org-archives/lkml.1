Return-Path: <linux-kernel-owner+w=401wt.eu-S1761334AbYAKJe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761334AbYAKJe4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 04:34:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755767AbYAKJet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 04:34:49 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:44446 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071AbYAKJer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 04:34:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=HG/0jsbgZeE7stEW3Taa22vVYyOAmoUJ1FVukmTx5x2NBl6ieGpeCFs2NDOITI+386Y7R/wzd+h/KF2bOknsNf7qe8GMmV/wbw+GOtLFM6OubWf/qoB1z8Wt1XpBcD/Tg/OQXyWNAPPhoi7+epCUjFn8aoauVo+rE+eFyc8rgGA=
Message-ID: <47873833.30001@gmail.com>
Date: Fri, 11 Jan 2008 10:34:43 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Daniel Walker <dwalker@mvista.com>
CC: Bernd Petrovitsch <bernd@firmix.at>, apw@shadowen.org,
       linux-kernel@vger.kernel.org, rdunlap@xenotime.net,
       jschopp@austin.ibm.com
Subject: Re: [PATCH] checkpatch.pl: allow piping
References: <20080111041120.085610726@mvista.com>	 <47872E35.3070705@gmail.com> <1200043035.29897.62.camel@imap.mvista.com>	 <47873505.7040008@gmail.com>  <1200043399.3905.9.camel@gimli.at.home> <1200043827.29897.70.camel@imap.mvista.com>
In-Reply-To: <1200043827.29897.70.camel@imap.mvista.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2008 10:30 AM, Daniel Walker wrote:
> On Fri, 2008-01-11 at 10:23 +0100, Bernd Petrovitsch wrote:
>> On Fre, 2008-01-11 at 10:21 +0100, Jiri Slaby wrote:
>>> git show 9914cad54c79d0b89b1f066c0894f00e1344131c
>> | ./scripts/checkpatch.pl -
>>
>> JftSoC:
>> git show 9914cad54c79d0b89b1f066c0894f00e1344131c
>> | ./scripts/checkpatch.pl /dev/stdin
>> (and there a a few others) should also do the trick.
> 
> Not a particularly attractive command line .. Might still be a good idea
> to add this since these two forms alluded me, and are likely to allude
> people new to unix all together (who is more likely to be using this
> particular tool)..

If somebody is hacking kernel, I think he should know the - trick used in many 
programs, but do not consider this as a nack.

thanks,
-- 
Jiri Slaby
Faculty of Informatics, Masaryk University
Suse Labs
