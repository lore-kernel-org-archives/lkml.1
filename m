Return-Path: <linux-kernel-owner+w=401wt.eu-S1759573AbYDASJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759573AbYDASJW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 14:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757996AbYDASJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 14:09:09 -0400
Received: from mga07.intel.com ([143.182.124.22]:15173 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757533AbYDASJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 14:09:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,588,1199692800"; 
   d="scan'208";a="226043926"
From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Organization: Intel Corporation
To: wimax@linuxwimax.org
Subject: [ANN] WiMAX stack and drivers for Intel WiMAX Link 5050
Date: Tue, 1 Apr 2008 11:07:37 -0700
User-Agent: KMail/1.9.9
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804011107.38563.inaky@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Intel would like to announce the initial release of a Linux WiMAX 
common stack and drivers for its WiMAX devices (eg: Intel(r) 
WiMAX/WiFi Link 5050, with estimated availability around third 
quarter of 2008).

The project follows a standard layered approach: a generic WiMAX 
kernel stack provides a common interface to control WiMAX devices. 
A user space daemon and libraries provide a high level API for 
control (network scanning, connection, disconnection, roaming 
management, etc) and access to the drivers. 

Currently much of this higher level code is tailored to Intel's 
device, but we wanted to get it out as soon as possible.

You can find the code and additional information at
http://linuxwimax.org.

