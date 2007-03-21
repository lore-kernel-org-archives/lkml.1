Return-Path: <linux-kernel-owner+w=401wt.eu-S1751218AbXCUBOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751218AbXCUBOK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 21:14:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751065AbXCUBOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 21:14:09 -0400
Received: from animx.eu.org ([216.98.75.249]:57052 "EHLO animx.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218AbXCUBOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 21:14:08 -0400
X-Greylist: delayed 1448 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Mar 2007 21:14:08 EDT
Date: Tue, 20 Mar 2007 20:48:30 -0400
From: Wakko Warner <wakko@animx.eu.org>
To: linux-kernel@vger.kernel.org
Subject: scsi: Devices offlined
Message-ID: <20070321004830.GA4901@animx.eu.org>
Mail-Followup-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6+20040907i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[84797.683873] sr 1:0:13:0: scsi: Device offlined - not ready after error recovery

Is there anyway to make the kernel "online" a device that has done this? 
I've had this happen on various devices (mostly on usb where I can
unplug/replug), but this time, it's on a scsi controller and the driver is
not a module.

If it's possible to do this w/o rebooting, I'd like to know for when I have
this happen in the future.

If it matters, the driver is aic79xx, kernel 2.6.20.

-- 
 Lab tests show that use of micro$oft causes cancer in lab animals
 Got Gas???
