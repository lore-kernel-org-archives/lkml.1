Return-Path: <linux-kernel-owner+w=401wt.eu-S1752691AbXBEEQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbXBEEQT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 23:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752692AbXBEEQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 23:16:19 -0500
Received: from terminus.zytor.com ([192.83.249.54]:36582 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbXBEEQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 23:16:18 -0500
Message-ID: <45C6AF81.1010908@zytor.com>
Date: Sun, 04 Feb 2007 20:16:01 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Luming Yu <luming.yu@gmail.com>
CC: Manu Abraham <abraham.manu@gmail.com>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, greg@kroah.com,
       Andrew Morton <akpm@osdl.org>
Subject: Re: 2.6.20 PCI Cannot allocate resource region 2
References: <1a297b360702041709l3b0309c7y8fcd33df1d487889@mail.gmail.com> <3877989d0702041904w1b57bb1dufbb731d2823d0b64@mail.gmail.com>
In-Reply-To: <3877989d0702041904w1b57bb1dufbb731d2823d0b64@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Luming Yu wrote:
> 
> *  Known BIOS problems we have to work around:
> *      - bogus I/O addresses above 64K used

On non-x86 architectures this might be just fine.

	-hpa
