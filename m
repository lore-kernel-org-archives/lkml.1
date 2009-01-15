Return-Path: <linux-kernel-owner+w=401wt.eu-S1764549AbZAOLYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764549AbZAOLYQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 06:24:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756037AbZAOLYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 06:24:00 -0500
Received: from 89.6b.364a.static.theplanet.com ([74.54.107.137]:51034 "EHLO
	cathcart.site5.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755436AbZAOLX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 06:23:59 -0500
Message-ID: <496F1CC2.5000108@compulab.co.il>
Date: Thu, 15 Jan 2009 13:23:46 +0200
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.16 (X11/20080907)
MIME-Version: 1.0
To: Jonathan Cameron <Jonathan.Cameron@gmail.com>
CC: Jonathan Cameron <jic23@cam.ac.uk>, LKML <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@sirena.org.uk>, Samuel Ortiz <sameo@openedhand.com>,
       eric miao <eric.y.miao@gmail.com>, felipe.balbi@nokia.com,
       Liam Girdwood <lrg@kernel.org>
Subject: Re: [PATCH 2.6.29-rc1-git4] mfd: da9030 usb charge pump support within
 mfd driver.
References: <496E2BE5.1050803@cam.ac.uk> <496ED9EF.2050507@compulab.co.il> <496F19E2.8070306@gmail.com>
In-Reply-To: <496F19E2.8070306@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cathcart.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Jonathan Cameron wrote:
> Mike Rapoport wrote:
>> Jonathan,
>> Below are my two cents :)
>>   
> Thanks,

>>>     
>> Maybe we want to have 'da9030_set_usb_charge_pump_mode' as well?
>>   
> (get?)

get of course :)

> Possibly though not sure under what circumstances it would be needed
> other than debugging?
> 

Somehow I thought I used it in the battery charger, but it seems I was wrong.


-- 
Sincerely yours,
Mike.

