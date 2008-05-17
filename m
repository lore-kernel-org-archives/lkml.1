Return-Path: <linux-kernel-owner+w=401wt.eu-S1754043AbYEQHMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbYEQHMz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 03:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbYEQHMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 03:12:44 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:28170 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbYEQHMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 03:12:44 -0400
Date: Sat, 17 May 2008 01:14:45 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Oops: 0000 [#1] SMP //// HPT raid card 1740
In-reply-to: <fa.aqNl8zEk9BVx+yTUacLsqIh/Rco@ifi.uio.no>
To: Marc Rantanen <marcr@kth.se>
Cc: linux-kernel@vger.kernel.org, support@highpoint-tech.com,
       support@microaurora.com.cn
Message-id: <482E85E5.4030907@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.aqNl8zEk9BVx+yTUacLsqIh/Rco@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marc Rantanen wrote:
> Can't get the new driver for HPT 1740 working in kernel gentoo-2.6.24-r8
> 
> module: rr174x (v.2.1)
> 
> /marc
> ------------------------
> rr174x: module license 'Proprietary' taints kernel.
> rr174x:RocketRAID 174x controller driver v2.1.08.0303 (May 16 2008 
> 15:58:03)
> BUG: unable to handle kernel paging request at virtual address 64091fd0
> printing eip: f8905688 *pde = 00000000
> Oops: 0000 [#1] SMP
> Modules linked in: rr174x(P) scsi_wait_scan

There is nothing kernel developers can do about this, you will have to 
contact Highpoint. Do you really need to use that binary driver?

