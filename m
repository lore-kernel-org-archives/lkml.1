Return-Path: <linux-kernel-owner+w=401wt.eu-S1752786AbZFEGQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbZFEGQ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 02:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751312AbZFEGQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 02:16:20 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:60150 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbZFEGQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 02:16:20 -0400
Message-ID: <4A28B81D.2070407@gmail.com>
Date: Fri, 05 Jun 2009 11:45:57 +0530
From: Pranith Kumar <pranith.hacks@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.0.12) Gecko/20070530 Red Hat/1.0.9-2.el4 SeaMonkey/1.0.9
MIME-Version: 1.0
To: Pranith Kumar <pranith.hacks@gmail.com>
CC: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [TRIVIAL][PATCH 1/1] Fix warning in staging/otus/ioctl.c
References: <430c80e90905290054n7416802cq7128394db5de036d@mail.gmail.com> <20090602214745.GB25921@kroah.com> <430c80e90906022349l6fa7a9b4lb73f0ab1980b3e63@mail.gmail.com> <20090603152152.GB25560@kroah.com> <4A27616C.6030802@gmail.com> <20090604175612.GB18605@kroah.com> <4A28A8BC.6090408@gmail.com>
In-Reply-To: <4A28A8BC.6090408@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Jun 2009 06:15:58.0117 (UTC) FILETIME=[175DFD50:01C9E5A5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pranith Kumar wrote:
> Greg KH wrote:
>> On Thu, Jun 04, 2009 at 11:23:48AM +0530, Pranith Kumar wrote:
>> Nope, the patch is linewrapped and the whitespace is still messed up :(
>>
>> Care to retry?
>>
>>   
> +++ b/drivers/staging/otus/ioctl.c
> @@ -2045,6 +2045,7 @@ int usbdrv_wpa_ioctl(struct net_device *dev, 
> struct athr_wlan_param *zdparm)

just verified on lkml, still line wrapped. Please drop this patch.

Thanks,
Pranith
