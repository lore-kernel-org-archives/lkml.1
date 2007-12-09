Return-Path: <linux-kernel-owner+w=401wt.eu-S1754373AbXLICes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373AbXLICes (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 21:34:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbXLICek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 21:34:40 -0500
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:59601 "EHLO
	outbound8-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753262AbXLICej convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 21:34:39 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.98.75;Service: EHS
Message-ID: <475B5439.6090803@am.sony.com>
Date: Sat, 08 Dec 2007 18:34:33 -0800
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Miguel_Bot=F3n?= <mboton.lkml@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ps3: "mm/Kconfig" fix
References: <200712082030.11338.mboton@gmail.com>
In-Reply-To: <200712082030.11338.mboton@gmail.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
X-OriginalArrivalTime: 09 Dec 2007 02:34:36.0381 (UTC) FILETIME=[0A1DE8D0:01C83A0C]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2007 11:30 AM, Miguel Botón wrote:
> sparsemem-make-sparsemem-vmemmap-selectable.patch introduces a little bug.
> 
> SPARSEMEM_VMEMMAP can be enabled in an architecture that doesn't support it. If the
> architecture supports SPARSEMEM_VMEMMAP, SPARSEMEM_VMEMMAP_ENABLE is enabled,
> so SPARSEMEM_VMEMMAP should depend on it.

sparsemem-make-sparsemem-vmemmap-selectable.patch is still only in my
ps3-linux-patches.git development repo.  I'll just fold this into the
original patch.  Thanks.

-Geoff 

