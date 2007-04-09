Return-Path: <linux-kernel-owner+w=401wt.eu-S965292AbXDITW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965292AbXDITW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 15:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965309AbXDITW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 15:22:28 -0400
Received: from ns2.g-housing.de ([81.169.133.75]:42394 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965292AbXDITW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 15:22:27 -0400
Date: Mon, 9 Apr 2007 20:21:57 +0100 (BST)
From: Christian Kujau <christian@g-house.de>
X-X-Sender: evil@sheep.housecafe.de
To: khali@linux-fr.org
cc: linux-kernel@vger.kernel.org
Subject: w83l785ts: Couldn't read value from register
Message-ID: <Pine.LNX.4.64.0704092012090.3963@sheep.housecafe.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've got this Asus A7N8X-X board and when using lm-sensors, these 
messages occasionally show up in my kernel logs:

w83l785ts 1-002e: Couldn't read value from register 0x53. Please report.

...and reporting is what I do with this email :)
Please see .config, dmidecode and more right here:
http://nerdbynature.de/bits/w83l785ts/

I suppose the message is informational anyway, since sensors(1) is 
working fine. Perhaps we can silence the printk to only show up when 
some debug-option is toggled?

Thanks,
Christian.
-- 
BOFH excuse #8:

static buildup
