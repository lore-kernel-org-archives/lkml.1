Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290Ab0BKWWx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 17:22:53 -0500
Received: from smtp.microsoft.com ([131.107.115.214]:50593 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756976Ab0BKWWw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 17:22:52 -0500
From: Hank Janssen <hjanssen@microsoft.com>
To: Greg KH <gregkh@suse.de>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 2/2] Staging: hv: General maintenance of TODO file
Thread-Topic: [PATCH 2/2] Staging: hv: General maintenance of TODO file
Thread-Index: AQHKq2HFt5YrdyjaOk+txGcH5EzUM5HB9GIA//+EmxA=
Date: Thu, 11 Feb 2010 22:22:19 +0000
Message-ID: <8AFC7968D54FB448A30D8F38F259C56212E88346@TK5EX14MBXC118.redmond.corp.microsoft.com>
References: <8AFC7968D54FB448A30D8F38F259C56212E881A9@TK5EX14MBXC118.redmond.corp.microsoft.com>
 <8AFC7968D54FB448A30D8F38F259C56212E88291@TK5EX14MBXC118.redmond.corp.microsoft.com>
 <20100211213816.GB29557@suse.de>
In-Reply-To: <20100211213816.GB29557@suse.de>
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

>> 
>> Removed two line;
>> 	Audit block driver
>> 	Audit scsi driver
>> They were added by us as part of the original code
>> Submission to make sure these drivers kept on working
>> Correctly with all the patches that came in from the 
>> Community. 
>
>Um, no, those things still need to be done.

What additional things are expected? We solved the original 
reason we added the lines, so I want to make sure we do 
additional work as is expected. We are going through general 
code cleanup, and the TODO file now. 

>> Added a new line to fix mostly insane camelcase naming
>> We are working on that right now, but it will take a bit
>> Due to the pervasive usage of it.
>
>That's fine, but it fits under the general "fix coding style issues".
>
>Hm, that isn't spelled out, but it is implicit, I doubt this really
>needs to be documented in the file, it's just common knowledge :)

Want me to add a proper line item for that? Or drop this patch
completely for the time being?

Thanks,

Hank.

