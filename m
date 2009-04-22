Return-Path: <linux-kernel-owner+w=401wt.eu-S1754708AbZDVRvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbZDVRvk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 13:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbZDVRvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 13:51:31 -0400
Received: from exprod6og104.obsmtp.com ([64.18.1.187]:36897 "HELO
	exprod6og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751406AbZDVRvb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 13:51:31 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] usb/host/ohci-hcd.c: fix sparse warnings
Date: Wed, 22 Apr 2009 13:50:56 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090165EFC9@mi8nycmail19.Mi8.com>
In-Reply-To: <20090422174212.GA18564@kroah.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] usb/host/ohci-hcd.c: fix sparse warnings
Thread-Index: AcnDcjmLKJBBGbvxSSuGQ8tvtKO/bAAAEsjg
References: <BD79186B4FD85F4B8E60E381CAEE1909015F8DFC@mi8nycmail19.Mi8.com> <20090422055327.GF9009@kroah.com> <BD79186B4FD85F4B8E60E381CAEE19090165EFC3@mi8nycmail19.Mi8.com> <20090422174212.GA18564@kroah.com>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Greg KH" <greg@kroah.com>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 22 Apr 2009 17:51:29.0000 (UTC) FILETIME=[F6BC6680:01C9C372]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 22, 2009 10:42 AM, Greg KH wrote:
> On Wed, Apr 22, 2009 at 01:39:34PM -0400, H Hartley Sweeten wrote:
>> On Tuesday, April 21, 2009 10:53 PM, Greg KH wrote:
>>> On Wed, Apr 15, 2009 at 10:04:17PM -0400, H Hartley Sweeten wrote:
>>> Fix sparse warnings in drivers/usb/host/ohci-hcd.c.
>>>> 
>>>> 	warning: symbol 'temp' shadows an earlier one
>>>> 
>>>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>>>
>>> I'm not seeing this sparse warning either.
>>>
>>> And you didn't fix the two sparse warnings I am seeing in this file,
>>> so I'm going to think this patch doesn't really do anything :(
>> 
>> Following are the sparse warnings I am seeing when building for an
>> EP93xx ARM platform:
>
> Ah, on ARM, sorry, I was building on x86.
>
> Care to respin this one, and your other one without the whitespace
> changes and line-wraps and resend them?

Not a problem. I will have to attach the patches to avoid the
line-warps.
It appears that the wrapping is occurring when my emails be bounced thru
one of my ISP's servers. I'm still trying to resolve that.

Question: How do you do a git diff and keep the whitespace changes out?

> thanks,
>
> greg k-h

Regards,
Hartley
