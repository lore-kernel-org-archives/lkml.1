Return-Path: <linux-kernel-owner+w=401wt.eu-S1755409AbZATCz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbZATCz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 21:55:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbZATCzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 21:55:11 -0500
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:15042 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbZATCzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 21:55:09 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=C8rkUfyEAAAA:8 a=VwQbUJbxAAAA:8 a=NBmVJhAIs6_HJH1CMlUA:9 a=5HIO3VYyWlgeif89k_AA:7 a=fACyyg9jtbzeuP7BiIdoUaxYnpwA:4 a=Y8cocX-fvF4A:10 a=PR-DjfqNVKsA:10
Message-ID: <49753D09.8060503@shaw.ca>
Date: Mon, 19 Jan 2009 20:55:05 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
Newsgroups: gmane.linux.ide,gmane.linux.kernel
To: Diego Calleja <diegocg@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Faulty seagate drives, are going to be blacklisted?
References: <20090120002923.065f24ca@diego-desktop>
In-Reply-To: <20090120002923.065f24ca@diego-desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Diego Calleja wrote:
> Tech sites are reporting everywhere a massive flaw in seagate drives that
> can lock up the drive and make it unusable (the bios doesn't detect it, you
> can't read the data). Haven't read anything about it here on the lists.
> Seagate has ack'ed the problem:
> http://seagate.custkb.com/seagate/crm/selfservice/search.jsp?DocId=207931
> 
> So, apparently there're a lot of drives on the market (including mine)
> that can die any day. Are those drives going to be blacklisted? It's
> still not clear if the firmware update is safe (some affected but
> working drives are dying after the firmware update), so some people
> like me is still waiting (and hoping that the drive doesn't die) for
> more stable firmware updates...
> 
> Here is the list of drives+firmware affected, according to the support site
> as of now. Some models are still being diagnosed.

There are a few drives which are currently marked to disable NCQ and 
warn the user that the firmware that should be upgraded:

ST31500341AS
ST31000333AS
ST3640623AS
ST3640323AS
ST3320813AS
ST3320613AS

all for firmware versions SD15 through SD19.

> 
> 
> Seagate Barracuda 7200.11 (http://seagate.custkb.com/seagate/crm/selfservice/search.jsp?DocId=207951)
> 
> Models Affected:
>  ST3500320AS
>  ST3640330AS
>  ST3750330AS
>  ST31000340AS
> Firmware Affected
>  SD15, SD16, SD17, SD18, SD19, AD14
> Recommended Firmware Update
>  SD1A
> 
> Seagate Barracuda 7200.11, page 2 (http://seagate.custkb.com/seagate/crm/selfservice/search.jsp?DocId=207957)
> Models Affected:
>  ST31500341AS
>  ST31000333AS
>  ST3640323AS
>  ST3640623AS
>  ST3320613AS
>  ST3320813AS
>  ST3160813AS
> Firmware Affected
>  Still Unknow
> Recommended Firmware Update
>  Still Unknow
> 
> 
> Seagate Barracuda ES.2 (http://seagate.custkb.com/seagate/crm/selfservice/search.jsp?DocId=207963)
> Models Affected:
>  ST3250310NS
>  ST3500320NS
>  ST3750330NS
>  ST31000340NS
> Firmware Affected
>  Still Unknow
> Recommended Firmware Update
>  Still Unknow
> 
> DiamondMax 22 (http://seagate.custkb.com/seagate/crm/selfservice/search.jsp?DocId=207969)
> Models Affected:
>  STM3500320AS
>  STM3750330AS
>  STM31000340AS
> Firmware Affected
>  MX15 (or higher)
> Recommended Firmware Update
>  MX1A
> 
> DiamondMax 22 (http://seagate.custkb.com/seagate/crm/selfservice/search.jsp?DocId=207975)
> Models Affected:
>  STM31000334AS
>  STM3320614AS
>  STM3160813AS
> Firmware Affected
>  Still Unknow
> Recommended Firmware Update
>  Still Unknow
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

