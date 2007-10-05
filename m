Return-Path: <linux-kernel-owner+w=401wt.eu-S1762219AbXJES2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762219AbXJES2R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 14:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbXJES2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 14:28:03 -0400
Received: from de01egw02.freescale.net ([192.88.165.103]:59115 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbXJES2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 14:28:01 -0400
Message-ID: <4706822D.4070509@freescale.com>
Date: Fri, 05 Oct 2007 13:27:57 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: __LITTLE_ENDIAN vs. __LITTLE_ENDIAN_BITFIELD
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

What's the difference between __LITTLE_ENDIAN and __LITTLE_ENDIAN_BITFIELD? 
Can someone give me an example when __BIG_ENDIAN and __LITTLE_ENDIAN_BITFIELD 
would both be defined simultaneously?

-- 
Timur Tabi
Linux Kernel Developer @ Freescale
