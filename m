Return-Path: <linux-kernel-owner+w=401wt.eu-S1751528AbZLVMVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528AbZLVMVU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 07:21:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbZLVMVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 07:21:19 -0500
Received: from cluster-d.mailcontrol.com ([85.115.60.190]:60540 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbZLVMVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 07:21:18 -0500
Message-ID: <4B30B975.20602@csr.com>
Date: Tue, 22 Dec 2009 12:20:05 +0000
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: peterhuewe@gmx.de
CC: Jiri Kosina <trivial@kernel.org>, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] uwb/i1480: add __init/__exit macros
References: <1261470431-23642-1-git-send-email-peterhuewe@gmx.de>
In-Reply-To: <1261470431-23642-1-git-send-email-peterhuewe@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Dec 2009 12:20:22.0615 (UTC) FILETIME=[223D9E70:01CA8301]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

peterhuewe@gmx.de wrote:
> From: Peter Huewe <peterhuewe@gmx.de>
> 
> Trivial patch which adds the __init/__exit macros to the module_init/
> module_exit functions of

Acked-by: David Vrabel <david.vrabel@csr.com>

Jiri, please merge this via the trivial tree, thanks.

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/


Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
