Return-Path: <linux-kernel-owner+w=401wt.eu-S1752278AbXBJLab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278AbXBJLab (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 06:30:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752274AbXBJLab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 06:30:31 -0500
Received: from smtp19.orange.fr ([80.12.242.1]:55996 "EHLO smtp19.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441AbXBJLaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 06:30:30 -0500
X-ME-UUID: 20070210113029274.42EA01C000AA@mwinf1926.orange.fr
Message-ID: <45CDACD3.3070007@wanadoo.fr>
Date: Sat, 10 Feb 2007 12:30:27 +0100
From: Thibaud Hulin <hulin.thibaud@wanadoo.fr>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Problem of USB - error 71 : how configure kernel to dongle with chipset
 SIS 163u
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi !
I'm trying to use a dongle with ndiswrapper, but it fails because a 
problem of usb. Indeed, when I put on first the dongle, a lsusb give :
Bus 001 Device 002: ID 0457:0163 Silicon Integrated Systems Corps.
Bus 001 Device 001: ID 0000:0000
But, 10 to 30 seconds later, the dongle is not recognize with an error -71.
lsusb give :
Bus 001 Device 001: ID 0000:0000
How can I configure the kernel to have the good configuration ? I tried 
different ways, but it fails.

Thanks for help,
Thibaud.

