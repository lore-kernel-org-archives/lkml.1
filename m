Return-Path: <linux-kernel-owner+w=401wt.eu-S1754060AbYLOPSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbYLOPSR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 10:18:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751192AbYLOPSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 10:18:06 -0500
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:60255 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbYLOPSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 10:18:05 -0500
Message-ID: <494674E2.3090602@csr.com>
Date: Mon, 15 Dec 2008 15:16:50 +0000
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/22] AMD IOMMU: use dev_name instead of self-build print_devid
References: <1229350685-3816-1-git-send-email-joerg.roedel@amd.com> <1229350685-3816-4-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1229350685-3816-4-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Dec 2008 15:16:51.0326 (UTC) FILETIME=[27EFB1E0:01C95EC8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> Impact: use generic dev_name instead of own function
  ^^^^^^
This has been bugging me for a while.  This word is redundant.

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/
