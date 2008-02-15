Return-Path: <linux-kernel-owner+w=401wt.eu-S1764879AbYBOW4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764879AbYBOW4Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 17:56:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764524AbYBOWla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 17:41:30 -0500
Received: from mga11.intel.com ([192.55.52.93]:9771 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764525AbYBOWl0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 17:41:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,360,1199692800"; 
   d="scan'208";a="519417249"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: ipw3945: not only it periodically dies, it also BUG()s
Date: Fri, 15 Feb 2008 14:41:08 -0800
Message-ID: <D936D925018D154694D8A362EEB0892003ABD431@orsmsx416.amr.corp.intel.com>
In-Reply-To: <20080206210026.GA32641@elf.ucw.cz>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: ipw3945: not only it periodically dies, it also BUG()s
Thread-Index: AchpA6GyVSSBv8TLQhGq6I6Yh6OVZQHIAHSQ
References: <20080205214441.GA1518@elf.ucw.cz> <D936D925018D154694D8A362EEB0892003982BB1@orsmsx416.amr.corp.intel.com> <20080206143218.GA16188@elf.ucw.cz> <D936D925018D154694D8A362EEB0892003982E4C@orsmsx416.amr.corp.intel.com> <20080206210026.GA32641@elf.ucw.cz>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Pavel Machek" <pavel@ucw.cz>
Cc: <ipw3945-devel@lists.sourceforge.net>, <linux-wireless@vger.kernel.org>,
       "Zhu, Yi" <yi.zhu@intel.com>,
       "kernel list" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 15 Feb 2008 22:41:24.0816 (UTC) FILETIME=[E4FF4500:01C87023]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 06, 2008 1:00 PM, Pavel Machek  wrote:

> Hmmm... bugzilla says:
> 
>    * Exact steps to reproduce
>    * Reproducability of bug (e.g. intermittent or 100% reproducable)
>    * Did this problem not exist in previous version of the driver?
>    * kernel version
>    * AP brand/model
>    * dmesg output at debug level 0x43fff
>      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 		it would be nice to specify how to do this. It is
> insmod parameter, right?
> 
>    * Type of security (if any) you are using (e.g. WEP64,
> WEP128, WPA, WPA2, 802.1x, etc)
>    * Version of firmware
>    * Version of the ieee80211 module
>    * Proximity to the AP
> 
>    * Before reporting any firmware errors, please be sure to read Ben
> Cahill's mailing list post on how to most effectively report such
>    bugs.
>
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> unfortunately the link here does not work. 

The instructions on how to report a bug have been updated to address the
above issues. Thank you very much for helping us to make it better.

Reinette
