Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934546Ab0BYXkc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 18:40:32 -0500
Received: from smtp.microsoft.com ([131.107.115.215]:42343 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934520Ab0BYXkb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 18:40:31 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: Hank Janssen <hjanssen@microsoft.com>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Problem with auto-detecting a HV environment from within Linux
Thread-Topic: Problem with auto-detecting a HV environment from within Linux
Thread-Index: AQHKtjnpPG+DB1+VDUmGCDmANJRAY5HXEhsAgACJl4D//4hyAIAA0+OA//+Bz6A=
Date: Thu, 25 Feb 2010 23:40:52 +0000
Message-ID: <1FB5E1D5CA062146B38059374562DF725B6A5806@TK5EX14MBXC130.redmond.corp.microsoft.com>
References: <20100225164436.GA3310@kroah.com>
 <1FB5E1D5CA062146B38059374562DF725B6A4277@TK5EX14MBXC130.redmond.corp.microsoft.com>
 <20100225173611.GA14124@kroah.com>
 <1FB5E1D5CA062146B38059374562DF725B6A5633@TK5EX14MBXC130.redmond.corp.microsoft.com>
 <20100225230639.GB20900@kroah.com>
In-Reply-To: <20100225230639.GB20900@kroah.com>
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

> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Thursday, February 25, 2010 6:07 PM
> If so, what is the vendor and product id of this device?

The Vendor:Device Id is: 1414:5353
00:08.0 VGA compatible controller [0300]: Microsoft Corporation Device [1414:5353]

This hasn't been changed since the first release of HyperV. I will ask around about the future stability of the VGA card (and the DMI).

Thanks,

- Haiyang

