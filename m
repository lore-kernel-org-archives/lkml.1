Return-Path: <linux-kernel-owner+w=401wt.eu-S1752238AbXLIGgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbXLIGgT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 01:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750985AbXLIGgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 01:36:11 -0500
Received: from defout.telus.net ([199.185.220.240]:41161 "EHLO
	defout.telus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbXLIGgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 01:36:10 -0500
Message-ID: <475B8CD9.3030809@telusplanet.net>
Date: Sat, 08 Dec 2007 23:36:09 -0700
From: Bob Gill <gillb4@telusplanet.net>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: RE: usb regression in 2.6.24-rc4
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.  Just a quick reply.  Is /proc/bus/usb empty?  Is there no symlink 
named devices (and so you can't cat devices to see what is there)?  
Also, (if /proc/bus/usb is empty), is /dev/bus/usb/devices not empty?  
(When you cat devices does it list usb devices you have plugged in?)  If 
so, then that's the problem I'm having.  Its very similar to yours, 
xsane points to the tv card only (not the scanner).  Something went away 
with the recent kernel.

Bob
