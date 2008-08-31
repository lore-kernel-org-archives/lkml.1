Return-Path: <linux-kernel-owner+w=401wt.eu-S1759606AbYHaN20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759606AbYHaN20 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 09:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758759AbYHaN2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 09:28:17 -0400
Received: from smtp-out1.iol.cz ([194.228.2.86]:48834 "EHLO smtp-out1.iol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758125AbYHaN2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 09:28:17 -0400
Message-ID: <48BA9B2C.7060007@quick.cz>
Date: Sun, 31 Aug 2008 15:22:52 +0200
From: Martin Doucha <next_ghost@quick.cz>
User-Agent: Thunderbird 2.0.0.14 (X11/20080620)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: ACPI PnP on Intel MU440EX
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I have trouble with ACPI PnP on one of my machines (Intel MU440EX 
motherboard made in '98). ACPI PnP doesn't detect built-in parallel port 
(PNPBIOS does and the port works because I use it to print regularly). I 
know that I can turn ACPI PnP off by editing .config or using 
pnpacpi=off boot parameter. I just want to report this problem before 
PNPBIOS support is dropped (as written in kernel docs).

I have no experience with kernel development or debugging but lots of 
experience with userspace development in C so you can ask whatever 
information you need.

Regards,
Martin Doucha
