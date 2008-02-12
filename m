Return-Path: <linux-kernel-owner+w=401wt.eu-S1762751AbYBLOHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762751AbYBLOHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 09:07:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759402AbYBLOHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 09:07:25 -0500
Received: from tranquility.mcc.ac.uk ([130.88.200.145]:52399 "EHLO
	tranquility.mcc.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759577AbYBLOHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 09:07:24 -0500
Message-ID: <47B1A865.30005@gentoo.org>
Date: Tue, 12 Feb 2008 14:08:37 +0000
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20080212)
MIME-Version: 1.0
To: sacarde@tiscali.it
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: List: linux-hotplug - how to debug udev
References: <200802111112.04031.sacarde@tiscali.it>
In-Reply-To: <200802111112.04031.sacarde@tiscali.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-UoM: Scanned by the University Mail System. See http://www.itservices.manchester.ac.uk/email/filtering/information/ for details.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should be asked on linux-hotplug and not linux-kernel, but anyway...

sacarde wrote:
> how can I view udev variables value ?
> 
> for examples:
> 
> what is value of:
> 
> BUS
>  SYSFS{idProduct}
>  SYSFS{idVendor}
> 
> when I insert my stick-usb wireless ?

This documentation should help you:
http://www.reactivated.net/writing_udev_rules.html

Daniel

