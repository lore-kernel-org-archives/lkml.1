Return-Path: <linux-kernel-owner+w=401wt.eu-S1946465AbXBIVzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946465AbXBIVzL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 16:55:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946157AbXBIVzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 16:55:11 -0500
Received: from mga06.intel.com ([134.134.136.21]:6598 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946151AbXBIVzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 16:55:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,308,1167638400"; 
   d="scan'208"; a="195081930:sNHT28209706"
Message-ID: <45CCE3CA.4050904@linux.intel.com>
Date: Fri, 09 Feb 2007 13:12:42 -0800
From: James Ketrenos <jketreno@linux.intel.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070104)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       ipw3945-devel@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [ANNOUNCE] d80211 based driver for Intel PRO/Wireless 3945ABG
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please hold all questions until I am done with this email.  Thank you.

We are pleased to announce the availability of a new driver for the 
Intel PRO/Wireless 3945ABG Network Connection adapter.  This new driver 
uses the new d80211 subsystem previously only available as part of the 
wireless-dev tree.

You can find the new driver, and additional information about it, here:

   http://intellinuxwireless.org/iwlwifi.

Within the new driver package are sources which we plan to submit for 
kernel inclusion as well as scripts and patches which create a version 
of the driver which can be loaded into kernels based on 2.6.18 and newer 
(provided you have installed the d80211 subsystem as well)  The README 
document can walk you through pretty quickly.

Since a lot of our users are not able to move to the latest versions of 
the Linux kernel, we have put together a d80211 package allowing the 
installation of the d80211 subsystem into an existing kernel image 
without the need to migrate to wireless-dev, or upgrade to a newer 
kernel at all (assuming you are using 2.6.18 or newer).

You can find that package at:

   http://intellinuxwireless.org/d80211

Ok.  Now... any questions?

Thanks,
James / Intel Corporation
