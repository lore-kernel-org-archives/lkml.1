Return-Path: <linux-kernel-owner+w=401wt.eu-S1756334AbYIRPfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334AbYIRPfG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 11:35:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219AbYIRPe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 11:34:56 -0400
Received: from de01egw02.freescale.net ([192.88.165.103]:46676 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110AbYIRPez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 11:34:55 -0400
Message-ID: <48D27510.3060803@freescale.com>
Date: Thu, 18 Sep 2008 10:34:40 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
CC: dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmatest: properly handle duplicate DMA channels
References: <1221751279-24936-1-git-send-email-timur@freescale.com> <20080918173258.2640000b@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <20080918173258.2640000b@hskinnemo-gx745.norway.atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Haavard Skinnemoen wrote:

> ...though I don't really see why you have to use
> list_for_entry_safe()...

You use it in dmatest_remove_channel(), so I figured I'd do the same thing.


-- 
Timur Tabi
Linux kernel developer at Freescale
