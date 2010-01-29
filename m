Return-Path: <linux-kernel-owner+w=401wt.eu-S1754709Ab0A2U3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab0A2U3Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 15:29:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893Ab0A2U3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 15:29:24 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:34194 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab0A2U3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 15:29:23 -0500
Message-ID: <4B634540.9070306@gawab.com>
Date: Fri, 29 Jan 2010 12:29:52 -0800
From: Justin Madru <jdm64@gawab.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091215 Shredder/3.0
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>, Willy Tarreau <w@1wt.eu>
Subject: Forward porting 2.4 driver
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have this Belkin router with the default firmware running 2.4.30. 
Belkin provided the source code as specified by the GPL. I was wondering 
how hard it would be to upgrade the kernel from 2.4.30 to 2.4.37.7. I 
know that 2.6 would be extremely hard because the driver model has 
changed so much. But, what changes happened between .30 and .37 that 
would make it difficult to upgrade the code? Did the driver model or 
other drastic changes happen? Could I just do a file diff; import the 
new files Belkin added and update the make files and kconfig?

The CPU and wireless card are based on the Ralink 2880/2860 or something 
like that.

Justin Madru
