Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496Ab0BKXre (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 18:47:34 -0500
Received: from maila.microsoft.com ([131.107.115.212]:53283 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757340Ab0BKXrd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 18:47:33 -0500
From: Hank Janssen <hjanssen@microsoft.com>
To: Greg KH <gregkh@suse.de>, Paul Mackerras <paulus@samba.org>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 2/2] Staging: hv: General maintenance of TODO file
Thread-Topic: [PATCH 2/2] Staging: hv: General maintenance of TODO file
Thread-Index: AQHKq2HFt5YrdyjaOk+txGcH5EzUM5HB9GIAgAAcsACAAANAAP//fTag
Date: Thu, 11 Feb 2010 23:46:48 +0000
Message-ID: <8AFC7968D54FB448A30D8F38F259C56212E8847D@TK5EX14MBXC118.redmond.corp.microsoft.com>
References: <8AFC7968D54FB448A30D8F38F259C56212E881A9@TK5EX14MBXC118.redmond.corp.microsoft.com>
 <8AFC7968D54FB448A30D8F38F259C56212E88291@TK5EX14MBXC118.redmond.corp.microsoft.com>
 <20100211213816.GB29557@suse.de>
 <20100211232056.GA13769@brick.ozlabs.ibm.com>
 <20100211233234.GA10315@suse.de>
In-Reply-To: <20100211233234.GA10315@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> On a side note, when this becomes mainstream, could you give it a more
>> descriptive name than just "hv"?  "Hv" already means at least two
>> possible things to me -- "hypervisor" or "high volume" -- neither of
>> which appear to be what this code is about.
>
>"hyperv" should be sufficient, right?
>
>thanks,
>
>greg k-h

I was thinking of using that, but would that confuse it with hypervisor
which is more of a general term?  If the consensus is that it would not than
I am in favor of changing it to hyperv.

ms_hyperv would make it to long?

Thanks,

Hank.

