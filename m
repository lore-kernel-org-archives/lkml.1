Return-Path: <linux-kernel-owner+w=401wt.eu-S1946804AbXBJL7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946804AbXBJL7S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 06:59:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946833AbXBJL7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 06:59:04 -0500
Received: from mga07.intel.com ([143.182.124.22]:17559 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946829AbXBJL7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 06:59:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,309,1167638400"; 
   d="scan'208"; a="179980893:sNHT17492454"
Message-ID: <45CDB370.2020401@linux.intel.com>
Date: Sat, 10 Feb 2007 12:58:40 +0100
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: OGAWA Hirofumi <hogawa@miraclelinux.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21 review I] [18/25] x86_64: Fix x86_64 ioremap base_address
References: <200702101250.142420000@suse.de> <20070210115031.3D4CE13DFB@wotan.suse.de>
In-Reply-To: <20070210115031.3D4CE13DFB@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> From: OGAWA Hirofumi <hogawa@miraclelinux.com>
> 
> Current mmconfig has some problems of remapped range.


eh wasn't there a patch that just ignored the MCFG for the broken 
system instead?
