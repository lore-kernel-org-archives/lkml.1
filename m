Return-Path: <linux-kernel-owner+w=401wt.eu-S1753247AbZHSWCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbZHSWCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 18:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbZHSWCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 18:02:19 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:64402 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbZHSWCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 18:02:18 -0400
Message-ID: <4A8C760F.9040003@oracle.com>
Date: Wed, 19 Aug 2009 15:00:47 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [RFC][PATCH 1/7] PM: Update kerneldoc comments in drivers/base/power/main.c
References: <200908122218.13975.rjw@sisk.pl> <200908170215.21173.rjw@sisk.pl> <200908170216.38401.rjw@sisk.pl> <200908192357.31358.rjw@sisk.pl>
In-Reply-To: <200908192357.31358.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt005.oracle.com [141.146.116.14]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4A8C75EB.00D4:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Monday 17 August 2009, Rafael J. Wysocki wrote:
>> From: Rafael J. Wysocki <rjw@sisk.pl>
>> Subject: PM: Update kerneldoc comments in drivers/base/power/main.c
>>
>> The kerneldoc comments in drivers/base/power/main.c are generally
>> outdated and some of them don't describe the functions very
>> accurately.  Update them and standardize the format to use spaces
>> instead of tabs.
>>
>> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Any objections to this patch from anyone?  Greg, Alan, Randy?

Nope, it's good.  Thanks.
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>


> Best,
> Rafael
> 
> 
>> ---
>>  drivers/base/power/main.c |  169 ++++++++++++++++++++++------------------------
>>  1 file changed, 84 insertions(+), 85 deletions(-)

