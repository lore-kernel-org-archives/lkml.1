Return-Path: <linux-kernel-owner+w=401wt.eu-S1757324AbYGPRgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324AbYGPRgm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 13:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774AbYGPRgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 13:36:33 -0400
Received: from cluster-d.mailcontrol.com ([217.69.20.190]:39737 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbYGPRgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 13:36:32 -0400
Message-ID: <487E317C.9040409@csr.com>
Date: Wed, 16 Jul 2008 18:35:56 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>
CC: Greg KH <greg@kroah.com>, linux-usb <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Dropping WUSB/UWB from my patch queue
References: <20080630180009.GA30833@kroah.com> <4871E9F0.60608@csr.com> <20080715155313.GA3075@kroah.com> <487CE2E7.90505@csr.com> <20080716054911.GA9806@kroah.com> <487DC4FA.4050505@csr.com> <C72DEB015BA7724783363DE1AF6B0F9805393C24@orsmsx417.amr.corp.intel.com>
In-Reply-To: <C72DEB015BA7724783363DE1AF6B0F9805393C24@orsmsx417.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jul 2008 17:35:56.0431 (UTC) FILETIME=[6737A9F0:01C8E76A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Perez-Gonzalez, Inaky wrote:
>> From: David Vrabel [mailto:david.vrabel@csr.com]
>>
>> Postponed:
>>
>> * HWA radio controller driver
>> * Wire Adapter core (for HWAs and DWAs).
>> * HWA host controller
>> * WLP support
>> * i1480 firmware download driver.
>> * i1480 WLP driver.
> 
> If I got you a fix for the USB reset stuff, would you be able to merge
> these guys?

That would be appreciated.  I just don't have the time to tackle tricky
problems with wired USB devices.

You will also want to add some documentation for any WLP sysfs files.

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/
