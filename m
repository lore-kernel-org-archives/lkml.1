Return-Path: <linux-kernel-owner+w=401wt.eu-S934502AbXHMQfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934502AbXHMQfW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966572AbXHMPk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 11:40:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:14778 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967191AbXHMPku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 11:40:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,255,1183359600"; 
   d="scan'208";a="278201554"
Message-ID: <46C07B5D.1080909@intel.com>
Date: Mon, 13 Aug 2007 08:40:13 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070623)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: joe@perches.com, torvalds@linux-foundation.org, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] [29/2many] MAINTAINERS - ADM1025 HARDWARE MONITOR DRIVER
References: <46bff89a.xYL7oyBOdTr8eyH/%joe@perches.com> <20070813113531.0632f551@hyperion.delvare>
In-Reply-To: <20070813113531.0632f551@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Aug 2007 15:40:48.0769 (UTC) FILETIME=[524E9710:01C7DDC0]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
> Hi Joe,
> 
> What a storm :( This should have been one single patch IMHO, or grouped
> by maintainer or subsystem or something.
> 
> On Sun, 12 Aug 2007 23:22:18 -0700, joe@perches.com wrote:
>> Add file pattern to MAINTAINER entry
> 
> Can you please point me to where this new pattern was discussed?

I came up with the idea at OLS talking to Dan Aloni, who posted the same problem 
but with a different solution (he suggested separate files in each directory).

See: http://lkml.org/lkml/2007/6/29/300

Joe did a great job on the perl script though ;)

Cheers,


Auke
