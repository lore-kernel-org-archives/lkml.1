Return-Path: <linux-kernel-owner+w=401wt.eu-S1763456AbYBSXL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763456AbYBSXL1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 18:11:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755186AbYBSXLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 18:11:19 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:35750 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749AbYBSXLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 18:11:19 -0500
Message-ID: <47BB6209.5080706@freescale.com>
Date: Tue, 19 Feb 2008 17:11:05 -0600
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Timur Tabi <timur@freescale.com>
CC: linuxppc-dev@ozlabs.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Difference between vmlinux and vmlinux.bin
References: <47BB5D82.6070806@freescale.com>
In-Reply-To: <47BB5D82.6070806@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Timur Tabi wrote:

> So when Kbuild creates vmlinux.bin, what does it do besides extract the PT_LOAD 
> segment?

Never mind, I was doing something stupid which was trashing my in-memory copy of 
vmlinux.bin.

-- 
Timur Tabi
Linux kernel developer at Freescale
